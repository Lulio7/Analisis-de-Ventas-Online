/* Vamos a comenzar creando la tabla para luego importar la informacion */

CREATE TABLE sales_data (
    TransactionID INT PRIMARY KEY,
    Date DATE,
    ProductCategory VARCHAR(255),
    ProductName VARCHAR(255),
    UnitsSold INT,
    UnitPrice DECIMAL(10, 2),
    TotalRevenue DECIMAL(10, 2),
    Region VARCHAR(255),
    PaymentMethod VARCHAR(255)
);

/* Análisis de Tendencias de Ventas: 
 las categorías y productos más vendidos. */

SELECT *
FROM sales_data;

SELECT
ProductCategory,
SUM(UnitsSold) AS Total_sales
FROM sales_data
GROUP BY ProductCategory
ORDER BY Total_sales DESC;

-- Las categorias mas vendidas son Clothing y Books

SELECT
ProductCategory,
SUM(TotalRevenue) AS Total_Rev
FROM sales_data
GROUP BY ProductCategory
ORDER BY Total_Rev DESC;

-- Pero las que mas ganancia generan son Electronics y Home 

SELECT
ProductCategory,
ProductName,
SUM(UnitsSold) AS Total_sales
FROM sales_data
GROUP BY ProductName, ProductCategory
ORDER BY Total_sales DESC
LIMIT 10;

-- 'Clothing', 'Hanes ComfortSoft T-Shirt', '10' es el articulo mas vendido

/* Esta consulta te proporciona el precio unitario promedio y la cantidad promedio vendida por producto. 
Puedes usar esta información para tener una idea inicial de cómo varían los precios y las cantidades vendidas. */

SELECT
ProductName,
AVG(UnitPrice) AS AvgUnitPrice,
AVG(UnitsSold) AS AvgUnitsSold,
COUNT(*) AS NumTransactions
FROM sales_data
GROUP BY ProductName
ORDER BY ProductName;

/* La moda es el valor que ocurre con más frecuencia en un conjunto de datos. 
En este caso, estamos buscando la categoría de producto que se vende más frecuentemente. */

SELECT
ProductCategory AS MostSoldProductCategory,
COUNT(*) AS Frequency
FROM sales_data
GROUP BY ProductCategory
ORDER BY Frequency DESC
LIMIT 1;

-- Nos encontramos con que la categoria para la moda es Electronics

SELECT
ProductName,
AVG(UnitPrice) AS AvgUnitPrice,
SUM(UnitsSold) AS TotalUnitsSold,
SUM(TotalRevenue) AS TotalRevenue
FROM sales_data
GROUP BY ProductName
ORDER BY TotalRevenue DESC;

-- Nos encontramos en el top con que los articulos de mayor revenue no se vendieron mas de 2 veces.
-- Se podria crear una estrategia de venta para potenciar estas ventas. 

/* Estacionalidad y Patrones Temporales: 
Analizar las ventas a lo largo del tiempo para identificar 
patrones estacionales y picos de ventas en fechas específicas. */

SELECT
YEAR(Date) AS Year,
MONTH(Date) AS Month,
SUM(TotalRevenue) AS TotalRevenue
FROM sales_data
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY TotalRevenue DESC;

-- Podemos observar que el primer trimestre fue el mas fuerte en cuanto a recaudacion

SELECT
YEAR(Date) AS Year,
MONTH(Date) AS Month,
SUM(UnitsSold) AS TotalUnitsSold
FROM sales_data
GROUP BY
YEAR(Date), MONTH(Date)
ORDER BY
YEAR(Date), MONTH(Date);
    
-- Mismo resultado en cuanto a unidades vendidas

SELECT
DAYOFWEEK(Date) AS DayOfWeek,
AVG(TotalRevenue) AS AvgRevenue
FROM sales_data
GROUP BY
DAYOFWEEK(Date)
ORDER BY AvgRevenue DESC;

-- Promedio de ventas con una distribucion pareja a lo largo de la semana

/* Rendimiento Regional: 
Evaluar el desempeño de las ventas en diferentes regiones geográficas 
para identificar mercados potenciales y oportunidades de expansión. */

SELECT
Region,
SUM(UnitsSold) AS Total_sales
FROM sales_data
GROUP BY Region
ORDER BY Total_sales DESC;

SELECT
Region,
SUM(TotalRevenue) AS Total_Rev
FROM sales_data
GROUP BY Region
ORDER BY Total_Rev DESC;

-- North America siendo la region principal de ganancia y Asia el de mas ventas

SELECT
Region,
monthname(Date) AS Year,
SUM(TotalRevenue) AS TotalSales
FROM sales_data
GROUP BY Region, monthname(Date)
ORDER BY TotalSales DESC;

-- Con esta querie podemos analizar los meses fuertes para cada continente

/* Esta consulta te proporcionará información sobre las preferencias 
de producto en cada región. Puedes identificar oportunidades para adaptar 
tu oferta de productos según las preferencias locales. */

SELECT 
Region,
ProductCategory,
COUNT(*) AS NumTransactions
FROM sales_data
GROUP BY Region, ProductCategory
ORDER BY Region, NumTransactions DESC;

-- Categorias predominantes para cada region

/* Esta consulta te ayudará a identificar regiones donde el rendimiento 
promedio de ventas es bajo pero hay un número significativo de transacciones. 
Estas podrían ser áreas donde valga la pena invertir para mejorar el rendimiento. */

SELECT
Region,
AVG(TotalRevenue) AS AvgSales,
COUNT(*) AS NumTransactions
FROM sales_data
GROUP BY Region
HAVING AVG(TotalRevenue) < (SELECT AVG(TotalRevenue) FROM sales_data)
ORDER BY
NumTransactions DESC;

-- Los resultados dan para las regiones de Europa y Asia

/* Optimización de Precios y Promociones: 
Analizar la relación entre precios unitarios y cantidades vendidas 
para optimizar estrategias de precios y promociones. */

SELECT 
MAX(UnitPrice),
MIN(UnitPrice),
AVG(UnitPrice)
FROM sales_data;

-- Primer analisis nos da que el precio mas alto es de 3899.99
-- Precio minimo de 6.50 y AVG en 236.39 

SELECT
ProductCategory,
    CASE
        WHEN UnitPrice >= 3500 THEN 'Muy alto'
        WHEN UnitPrice >= 2000 AND UnitPrice < 3500 THEN 'Alto'
        WHEN UnitPrice >= 1000 AND UnitPrice < 2000 THEN 'Medio'
        WHEN UnitPrice >= 500 AND UnitPrice < 1000 THEN 'Bajo'
        WHEN UnitPrice < 500 THEN 'Muy bajo'
        ELSE 'Desconocido'
    END AS PriceCategory
FROM sales_data
ORDER BY ProductCategory ASC;

-- Vamos a contar cuantos articulos hay por categorias

SELECT
ProductCategory,
COUNT(DISTINCT ProductName) AS Individual_Count
FROM sales_data
GROUP BY ProductCategory;

-- Tenemos una cantidad pareja entre categorias 

SELECT
ProductName,
ProductCategory,
ROUND(AVG(UnitPrice),2) AS AvgUnitPrice,
AVG(UnitsSold) AS AvgUnitsSold,
COUNT(*) AS NumTransactions
FROM sales_data
GROUP BY ProductName, ProductCategory
ORDER BY AvgUnitsSold DESC;

-- Confirmamos que las principales ventas son de precios debajo de los 500.

/* Preferencias de Pago: 
Investigar las preferencias de los clientes en cuanto 
a métodos de pago para mejorar la experiencia de compra. */

SELECT
PaymentMethod,
SUM(UnitsSold) AS Total_sales
FROM sales_data
GROUP BY PaymentMethod
ORDER BY Total_sales DESC;

-- Cantidad de ventas mas concretadas por tarjeta de credito

SELECT
PaymentMethod,
SUM(TotalRevenue) AS Total_Rev
FROM sales_data
GROUP BY PaymentMethod
ORDER BY Total_Rev DESC;

-- Metodo mas usado Credit Card tambien es el que deja mas ganacia

SELECT
PaymentMethod,
COUNT(*) AS NumTransactions
FROM sales_data
GROUP BY PaymentMethod
ORDER BY NumTransactions DESC;
    
-- La tarjeta de credito tambien se centra en el medio con mas transacciones.

SELECT
PaymentMethod,
AVG(TotalRevenue) AS AvgRevenuePerTransaction
FROM sales_data
GROUP BY PaymentMethod
ORDER BY AvgRevenuePerTransaction DESC;

-- El promedio de ingreso se duplica en promedio con la tarjeta de credito

SELECT
ProductCategory,
PaymentMethod,
COUNT(*) AS NumTransactions
FROM sales_data
GROUP BY ProductCategory, PaymentMethod
ORDER BY ProductCategory, NumTransactions DESC;

-- Dependiendo de la categoria vemos variaciones en los metodos de pago
-- Esto podria deberse al valor de los productos 

/* Esta consulta te ayudará a ver la evolución de las preferencias de pago mes a mes o año a año. 
Puedes identificar tendencias estacionales o cambios en las preferencias de pago con el tiempo. */

SELECT
MONTHNAME(Date) AS Month,
PaymentMethod,
COUNT(*) AS NumTransactions
FROM sales_data
GROUP BY MONTHNAME(Date), PaymentMethod
ORDER BY MONTHNAME(Date), NumTransactions DESC;

-- Dependiendo la estacionalidad y festividades se podria explicar las fluctuaciones de transacciones
-- y tipos de medios de pago utilizados.


