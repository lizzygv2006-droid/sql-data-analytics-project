/*
===============================================================================
Exploración de dimensiones 
===============================================================================
Proposito:
    - Explorar la estructura de las dimensiones de las tablas.
	
Funciones SQL usadas:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Obtener una lista de paises únicos de los cuales los clientes son originarios.
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;

-- Obtener una lista de categorias, subcategorias, y productos únicos
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
