/*
===============================================================================
Análisis de magnitud
===============================================================================
Proposito:
    - Para cuantificar datos y agrupar resultados por dimensiones específicas.
    - Para comprender la distribución de los datos entre categorías.

Funciones SQL usadas:
    - Funciones de agregación: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/
--Encontrar total de clientes por pais 
SELECT 
	country,
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;


--Encontrar el total de clientes por genero
SELECT 
	gender,
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

--Encontrar el total de productos por categoría 
SELECT 
	category,
	COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

--Cuál es el costo promedio para cada categoría?
SELECT 
	category,
	ROUND(AVG(cost),0) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

--Cuáles son los ingresos totales generados por cada categoría?
SELECT 
	p.category,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY category
ORDER BY total_revenue DESC;

--Cuál es el total de ingresos generado por cada cliente
SELECT
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC;

--Cuál es la cantidad de productos vendidos en cada pais.
SELECT 
	c.country,
	SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;
