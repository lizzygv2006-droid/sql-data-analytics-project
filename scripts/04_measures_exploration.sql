/*
===============================================================================
Exploración de medidas (Key Metrics)
===============================================================================
Proposito:
    - Para calcular métricas agregadas (e.j., totales, promedios) para obtener información rápida.
    - Para identificar tendencias generales o detectar anomalías.

Funciones SQL usadas:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

--Encontrar el total de ventas 
SELECT 
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

--Encontrar cuantos elementos fueron vendidos
SELECT 
	SUM(quantity) AS total_quantity
FROM gold.fact_sales;

--Encontrar el precio promedio
SELECT 
	ROUND(AVG(price),0) AS avg_price
FROM gold.fact_sales;

--Encontrar el total de ordenes 
SELECT 
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

--Encontrar el total de productos
SELECT 
	COUNT(product_key) as total_products
FROM gold.dim_products;

--Encontrar el total de clientes 
SELECT 
	COUNT(customer_key) as total_customers
FROM gold.dim_customers;

--Encontrar el total de clientes que han ordenado 
SELECT 
	COUNT(DISTINCT customer_key) as total_customers
FROM gold.dim_customers;

--Generar un reporte que muestre todas las metricas claves del negocio 
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', ROUND(AVG(price),0)FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products', COUNT(product_key) FROM gold.dim_products
UNION ALL 
SELECT 'Total Nr. Customers', COUNT(customer_key) FROM gold.dim_customers;
