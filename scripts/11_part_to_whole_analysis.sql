/*
===============================================================================
Análisis de parte sobre el todo
===============================================================================
Propósito:
    - Comparar el rendimiento o las métricas entre dimensiones o períodos de tiempo.
    - Evaluar diferencias entre categorías.
    - Útil para pruebas A/B o comparaciones regionales.

Funciones SQL utilizadas:
    - SUM(), AVG(): Agregan valores para su comparación.
    - Funciones de ventana: SUM() OVER() para cálculos de totales.
===============================================================================
*/
-- ¿Qué categorías contribuyen más a las ventas totales?

WITH category_sales AS (
	SELECT 
		p.category,
		SUM(f.sales_amount) AS total_sales
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
	ON f.product_key = p.product_key
	GROUP BY p.category
)

SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER() AS overall_sales,
	CONCAT(ROUND((CAST(total_sales AS DECIMAL) / SUM(total_sales) OVER())*100, 2),'%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
