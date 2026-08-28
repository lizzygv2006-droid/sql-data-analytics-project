/*
===============================================================================
Análisis de rendimiento (Year-over-Year, Month-over-Month)
===============================================================================
Propósito:
    - Medir el rendimiento de productos, clientes o regiones a lo largo del tiempo.
    - Realizar evaluaciones comparativas (benchmarking) e identificar entidades de alto rendimiento.
    - Seguimiento de tendencias anuales y del crecimiento.

Funciones SQL utilizadas:
    - LAG(): Accede a datos de filas anteriores.
    - AVG() OVER(): Calcula valores promedio dentro de particiones.
    - CASE: Define lógica condicional para el análisis de tendencias.
===============================================================================
*/

/*Analice el rendimiento anual de los productos comparando sus ventas tanto 
con el rendimiento de ventas promedio del producto como con las ventas del año anterior.*/

WITH yearly_product_sales AS (
SELECT 
	p.product_name,
	TO_CHAR(DATE_TRUNC('YEAR', f.order_date), 'YYYY') AS order_year,
	SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY 
	DATE_TRUNC('YEAR', f.order_date),
	p.product_name
)

SELECT 
	order_year,
	product_name,
	current_sales,
	ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0) AS avg_sales,
	current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0) AS diff_avg,
	CASE 
		WHEN current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0) > 0 THEN 'Above avg'
		WHEN current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0) < 0 THEN 'Below avg'
		ELSE 'AVG'
	END avg_change,
	--Year-Over-Year ANALYSIS
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales, --py stands for previous year
	current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py,
	CASE 
		WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		ELSE 'No Change'
	END py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;
