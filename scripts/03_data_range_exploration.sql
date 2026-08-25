/*
===============================================================================
Exploración de rango de datos (Data range Exploration)
===============================================================================
Proposito:
    - Determinar los límites temporales de puntos de datos clave.
    - Para comprender el rango de datos históricos.

Funciones SQL usadas:
    - MIN(), MAX() EXTRACT()
===============================================================================
*/

--Encontrar la fecha de la primera y última orden
--Rango de años de venta
SELECT 
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) AS order_range_years
FROM gold.fact_sales;

--Encontrar el cliente más joven y el más mayor
SELECT 
MIN(birthday) AS oldest_birthdate,
MAX(birthday) AS youngest_birthdate,
EXTRACT(YEAR FROM AGE(MIN(birthday))) oldest_age,
EXTRACT(YEAR FROM AGE(MAX(birthday))) youngest_age
FROM gold.dim_customers;
