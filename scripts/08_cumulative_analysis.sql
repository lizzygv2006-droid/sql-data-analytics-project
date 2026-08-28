/*
===============================================================================
Análisis acumulativo
===============================================================================
Proposito:
    - Para calcular totales acumulados o medias móviles de métricas clave.
    - Para realizar un seguimiento acumulativo del rendimiento a lo largo del tiempo.
    - Útil para el análisis del crecimiento o para identificar tendencias a largo plazo.

Funciones SQL usadas:
    - Funciones de ventana: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calcular el total de ventas por mes 
-- y el total acumulado de ventas a lo largo del tiempo.
	SELECT 
	order_date, 
	total_sales, 
	SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales,
	avg_price,
	ROUND(AVG(avg_price) OVER(ORDER BY order_date),0) AS moving_avg_price
FROM (
	SELECT 
		DATE_TRUNC('MONTH', order_date) AS order_date,
		SUM(sales_amount) AS total_sales,
		ROUND(AVG(price),0) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATE_TRUNC('MONTH', order_date)
);
