/*
===============================================================================
Análisis de segmentación de datos
===============================================================================
Propósito:
    - Agrupar datos en categorías significativas para obtener información específica.
    - Para segmentación de clientes, categorización de productos o análisis regional.

Funciones SQL utilizadas:
    - CASE: Define lógica de segmentación personalizada.
    - GROUP BY: Agrupa datos en segmentos.
===============================================================================
*/

/*Segmentar productos en rangos de costos y 
contar cuántos productos pertenecen a cada segmento*/
WITH product_segment AS (
	SELECT
		product_key,
		product_name,
		cost,
		CASE 
			WHEN cost < 100 Then 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 501 AND 1000 THEN '501-1000'
			ELSE 'Above 1000'
		END cost_range
	FROM gold.dim_products
)

SELECT 
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC;

/* Basados en cuanto dinero gastó el cliente, agrupalos en distintas categorías:
	-VIP: Clientes con al menos 12 meses de historial y con un gasto mayor de $5000
	-Regular: Clientes con al menos 12 meses de historial pero con un gasto de $5000 o menos 
	-Nuevo: Clientes con un historial menor a 12 meses 
Y encuentra el total de clientes en cada grupo.
*/

WITH customer_spending AS (
	SELECT 
		c.customer_key,
		SUM(f.sales_amount) AS total_spending,
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order, 
		EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))* 12) +
		EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS life_span
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_customers AS c
	ON f.customer_key = c.customer_key
	GROUP BY c.customer_key
)

SELECT 
	COUNT(customer_key) AS total_customers,
	CASE 
		WHEN total_spending > 5000 AND life_span >= 12 THEN 'VIP'
		WHEN total_spending <= 5000  AND life_span >= 12 THEN 'Regular'
		ELSE 'Nuevo'
	END customer_segment
FROM customer_spending
GROUP BY customer_segment
ORDER BY total_customers DESC;
