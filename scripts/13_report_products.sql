/*
================================================================================
REPORTE SOBRE PRODUCTOS
================================================================================
Proposito: 
	-Este reporte consolida metricas y comportamientos claves de los productos
Puntos claves:
	1.Recopilar campos esenciales como nombre, categoria, subcategoria y costo.
	2.Segmentar productos por ingresos para identificar rendimiento alto, medio y bajo.
	3. Agregar metricas a nivel de los productos:
		-Total de ordenes
		-Total de Ventas
		-Total de cantidades vendidas
		-Total de clientes (únicos)
		-Duración en meses del producto (lifespan)
	4. Calcular importantes indicadores claves de desempeño (KPIs):
		-Recencia (meses desde la última orden)
		-Valor promedio del pedido
		-Ingreso promedio mensual
=================================================================================
*/ 

CREATE OR REPLACE VIEW gold.report_products AS (
WITH base_query AS (
/*---------------------------------------------------------------------------------
1) Consulta Base: Obtener las columnas principales de fact_sales and dim_products
---------------------------------------------------------------------------------*/
	SELECT 
		f.order_number,
		f.order_date,
		f.customer_key,
		f.sales_amount,
		f.quantity,
		p.product_key, 
		p.product_name,
		p.category,
		p.subcategory,
		p.cost
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
	ON f.product_key = p.product_key 
	WHERE order_date IS NOT NULL --Solo considerando fechas de pedidos válidas 
)
, product_aggregation AS (
/*---------------------------------------------------------------------------------
1) Agrupar datos de productos: Resumir metricas claves a nivel de productos.
---------------------------------------------------------------------------------*/
	SELECT 
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))*12) + 
		EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS life_span,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT customer_key) AS total_customers,
		MAX(order_date) AS last_sale_date,
		ROUND(AVG(CAST(sales_amount AS DECIMAL) / NULLIF(quantity, 0)),1) AS avg_selling_price
	FROM base_query
	GROUP BY 
		product_key,
		product_name,
		category,
		subcategory,
		cost
)
/*---------------------------------------------------------------------------------------
3) Consulta Final: Consolidar los resultados de todos los productos en un solo resultado
-----------------------------------------------------------------------------------------*/
SELECT 
product_key,
product_name,
category,
subcategory,
cost,
last_sale_date,
EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_sale_date)*12) + 
EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_sale_date)) AS recency_in_months,
Case 
	WHEN total_sales > 50000 THEN 'Rendimiento Alto'
	WHEN total_sales >= 10000 THEN 'Rendimiento Medio'
	ELSE 'Rendimiento bajo'
END product_segment,
life_span,
total_orders,
total_sales,
total_quantity,
total_customers,
avg_selling_price,
--Calcular el valor promedio del pedido
CASE WHEN total_orders = 0 THEN 0
ELSE total_sales / total_orders
END AS avg_order_revenue,
--Calcular el gasto promedio mensual
CASE WHEN life_span = 0 THEN total_sales
ELSE ROUND(total_sales / life_span, 0) 
END AS avg_monthly_revenue
FROM product_aggregation
);
