/*
===============================================================================
Análisis de clasificación (Ranking Analysis)
===============================================================================
Proposito:
    - Clasificar elementos (e.j., productos, clientes) basado en el rendimiento u otras métricas.
    - Para identificar a los de mejor desempeño o a los de menor desempeño.

Funciones SQL usadas:
    - funciones de ventana de clasificación: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

--Cuales son los 5 productos que generan más ingresos?
SELECT 
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

--Con window function

SELECT 
	p.product_name,
	SUM(f.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) AS rank_products
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
GROUP BY p.product_name
LIMIT 5;

--Cuales son los 5 productos que generan menos ingresos?
SELECT 
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC
LIMIT 5;

--Encuentra los 10 clientes que han generado mas ingresos
SELECT 
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC
LIMIT 10;

--Encuentra los 3 clientes que han generado menos ingresos
SELECT 
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue ASC
LIMIT 3;
