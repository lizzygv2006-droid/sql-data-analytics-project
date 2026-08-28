/*
================================================================================
REPORTE SOBRE CLIENTES 
================================================================================
Proposito: 
	-Este reporte consolida metricas y comportamientos claves de clientes 
Puntos claves:
	1.Recopilar campos esenciales como nombre, edad, y detalles transaccionales
	2.Segmentar clientes en categorias (VIP, Regular, Nuevo) y grupos de edad
	3. Agregar metricas a nivel de cliente:
		-Total de ordenes
		-Total de Ventas
		-Total de cantidad comprada 
		-Total de productos
		-Duración en meses del cliente (lifespan)
	4. Calcular importantes indicadores claves de desempeño (KPIs):
		-Recencia (meses desde la última orden)
		-Valor promedio de compra
		-Gasto promedio mensual
=================================================================================
*/ 

CREATE OR REPLACE VIEW gold.report_customers AS (
WITH base_query AS (
/*---------------------------------------------------------------------------------
1) Consulta Base: Obtener las columnas principales de la tabla.
---------------------------------------------------------------------------------*/
	SELECT 
		f.order_number,
		f.product_key,
		f.order_date,
		f.sales_amount,
		f.quantity,
		c.customer_key, 
		c.customer_number,
		CONCAT(c.first_name,' ', c.last_name) AS customer_name,
		EXTRACT(YEAR FROM AGE(birthdate)) AS customer_age
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_customers AS c
	ON f.customer_key = c.customer_key 
	WHERE order_date IS NOT NULL
)
, customer_aggregation AS (
/*---------------------------------------------------------------------------------
1) Agrupar datos de clientes: Resumir metricas claves a nivel de clientes.
---------------------------------------------------------------------------------*/
	SELECT 
		customer_key,
		customer_number,
		customer_name,
		customer_age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order_date,
		EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))*12) + 
		EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS life_span
	FROM base_query
	GROUP BY 
		customer_key,
		customer_number,
		customer_name,
		customer_age
)

/*---------------------------------------------------------------------------------------
3) Consulta Final: Consolidar los resultados de todos los clientes en un solo resultado
-----------------------------------------------------------------------------------------*/
SELECT 
	customer_key,
	customer_number,
	customer_name,
	customer_age,
	CASE 
		WHEN customer_age < 20  THEN 'Menor a 20'
		WHEN customer_age BETWEEN 20 AND 29 THEN '20-29'
		WHEN customer_age BETWEEN 30 AND 39 THEN '30-39'
		WHEN customer_age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 o mas'
	END age_group,
	CASE 
		WHEN total_sales > 5000 AND life_span >= 12 THEN 'VIP'
		WHEN total_sales <= 5000  AND life_span >= 12 THEN 'Regular'
		ELSE 'Nuevo'
	END customer_segment,
	EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_order_date)*12) + 
	EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_order_date)) AS recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	life_span,
	--Calcular el valor promedio de compra 
	CASE WHEN total_sales = 0 THEN 0
	ELSE total_sales / total_orders
	END AS avg_order_value,
	--Calcular el gasto promedio mensual
	CASE WHEN life_span = 0 THEN total_sales
	ELSE ROUND(total_sales / life_span, 0) 
	END AS avg_monthly_spend
FROM customer_aggregation
);
