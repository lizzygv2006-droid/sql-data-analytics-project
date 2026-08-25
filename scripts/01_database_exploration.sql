/*
===============================================================================
Exploración de la base de datos (Database Exploration)
===============================================================================
Proposito:
    - Explorar la estrutura de la base de datos, incluyendo la lista de tablas y sus esquemas.
    - Inspeccionar las columnas y metadatos de tablas específicas 

Uso:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/
-- Obtener una lista de todas las tablas de la base de datos 
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

-- Obtener todas las columnas de una tabla específica (dim_customers)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
