/*
===============================================================================
Análisis de cambios a lo largo del tiempo 
===============================================================================
Proposito:
    - Rastrear tendencias, crecimientos, y cambios en métricas claves a lo largo del tiempo.
    - Para el análisis de series temporales y la identificación de la estacionalidad.
    - Para medir el crecimiento o el descenso durante períodos específicos.

Funciones SQL usadas:
    - Funciones de fecha: EXTRACT(), DATE_TRUNC(), TO_CHAR()
    - Funciones de agregación: SUM(), COUNT(), AVG()
===============================================================================
*/
-- Analizar el rendimiento de ventas a lo largo del tiempo (Años)
SELECT 
	EXTRACT(YEAR FROM order_date) AS sales_year,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date);

-- Analizar el rendimiento de ventas a lo largo del tiempo (meses)
SELECT 
	EXTRACT(MONTH FROM order_date) AS sales_month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(MONTH FROM order_date);

--Rendimiento de ventas segmentados en año y mes
SELECT 
  TO_CHAR(DATE_TRUNC('MONTH', order_date), 'yyyy-mon') AS order_date,
  SUM(sales_amount) AS total_sales,
  COUNT(DISTINCT customer_key) AS total_customers,
  SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('MONTH', order_date)
ORDER BY DATE_TRUNC('MONTH', order_date);
