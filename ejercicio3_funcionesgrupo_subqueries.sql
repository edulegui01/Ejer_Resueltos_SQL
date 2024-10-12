1. El salario de cada empleado está dado por su posición, y la asignación de la categoría vigente en dicha posición. 
Tanto la posición como la categoría vigente tienen la fecha fin nula 
– Un solo salario está vigente en un momento dado). 
Tomando como base la lista de empleados, verifique cuál es el salario máximo, el mínimo y el promedio. 
Formatee la salida para que se muestren los puntos de mil.


SELECT MAX(CS.ASIGNACION) AS MAXIMO, MIN(CS.ASIGNACION) AS MINIMO, AVG(CS.ASIGNACION) 
FROM B_EMPLEADOS E
JOIN B_POSICION_ACTUAL PP
    ON E.CEDULA = PP.CEDULA
JOIN B_CATEGORIAS_SALARIALES CS
    ON PP.COD_CATEGORIA = CS.COD_CATEGORIA
WHERE PP.FECHA_FIN IS NULL AND CS.FECHA_FIN IS NULL



2. Basado en la consulta anterior, determine la mayor y menor asignación en cada área. 
Su consulta tendrá: Nombre de área, Asignación Máxima, Asignación Mínima.

SELECT A.ID, A.NOMBRE_AREA, MAX(CS.ASIGNACION) AS MAXIMO, MIN(CS.ASIGNACION) AS MINIMO, AVG(CS.ASIGNACION) 
FROM B_EMPLEADOS E
JOIN B_POSICION_ACTUAL PP
    ON E.CEDULA = PP.CEDULA
JOIN B_CATEGORIAS_SALARIALES CS
    ON PP.COD_CATEGORIA = CS.COD_CATEGORIA
JOIN B_AREAS A
    ON PP.ID_AREA = A.ID
WHERE PP.FECHA_FIN IS NULL AND CS.FECHA_FIN IS NULL
GROUP BY A.ID, A.NOMBRE_AREA


3. Determine el nombre y apellido, nombre de categoría, asignación y área del empleado (o empleados) 
que tienen la máxima asignación vigente. Pruebe con un subquery normal, y luego con la cláusula WITH:


SELECT E.NOMBRE ||' '||E.APELLIDO,CS.NOMBRE_CAT, CS.ASIGNACION, A.NOMBRE_AREA
FROM B_EMPLEADOS E
JOIN B_POSICION_ACTUAL PA
    ON E.CEDULA = PA.CEDULA
JOIN B_CATEGORIAS_SALARIALES CS
    ON PA.COD_CATEGORIA = CS.COD_CATEGORIA
JOIN B_AREAS A
    ON PA.ID_AREA = A.ID
WHERE CS.ASIGNACION = (SELECT MAX(CS.ASIGNACION)
        FROM B_POSICION_ACTUAL PA 
        JOIN B_CATEGORIAS_SALARIALES CS
            ON PA.COD_CATEGORIA = CS.COD_CATEGORIA WHERE PA.FECHA_FIN IS NULL AND CS.FECHA_FIN IS NULL)



WITH asignacion_max as
(SELECT E.NOMBRE ||' '||E.APELLIDO AS EMPLEADO,CS.NOMBRE_CAT, CS.ASIGNACION, A.NOMBRE_AREA
FROM B_EMPLEADOS E
JOIN B_POSICION_ACTUAL PA
    ON E.CEDULA = PA.CEDULA
JOIN B_CATEGORIAS_SALARIALES CS
    ON PA.COD_CATEGORIA = CS.COD_CATEGORIA
JOIN B_AREAS A
    ON PA.ID_AREA = A.ID)
SELECT am.EMPLEADO, am.NOMBRE_CAT, am.ASIGNACION, am.NOMBRE_AREA
FROM asignacion_max am
WHERE am.ASIGNACION = (SELECT MAX(am.ASIGNACION) maximo
                        FROM asignacion_max am)



4. Determine el nombre y apellido, nombre de categoría, asignación y área del empleado (o empleados) 
que tienen una asignación INFERIOR al promedio. Ordene por monto de salario en forma DESCENDENTE. 
Intente la misma consulta con y sin WITH.

SELECT E.NOMBRE ||' '||E.APELLIDO,CS.NOMBRE_CAT, CS.ASIGNACION, A.NOMBRE_AREA
FROM B_EMPLEADOS E
JOIN B_POSICION_ACTUAL PA
    ON E.CEDULA = PA.CEDULA
JOIN B_CATEGORIAS_SALARIALES CS
    ON PA.COD_CATEGORIA = CS.COD_CATEGORIA
JOIN B_AREAS A
    ON PA.ID_AREA = A.ID
WHERE CS.ASIGNACION < (SELECT AVG(CS.ASIGNACION)
        FROM B_POSICION_ACTUAL PA 
        JOIN B_CATEGORIAS_SALARIALES CS
            ON PA.COD_CATEGORIA = CS.COD_CATEGORIA WHERE PA.FECHA_FIN IS NULL AND CS.FECHA_FIN IS NULL)
ORDER BY CS.ASIGNACION DESC


WITH PROMEDIO_MENOR as
(SELECT E.NOMBRE ||' '||E.APELLIDO AS EMPLEADO,CS.NOMBRE_CAT, CS.ASIGNACION, A.NOMBRE_AREA
FROM B_EMPLEADOS E
JOIN B_POSICION_ACTUAL PA
    ON E.CEDULA = PA.CEDULA
JOIN B_CATEGORIAS_SALARIALES CS
    ON PA.COD_CATEGORIA = CS.COD_CATEGORIA
JOIN B_AREAS A
    ON PA.ID_AREA = A.ID)
SELECT am.EMPLEADO, am.NOMBRE_CAT, am.ASIGNACION, am.NOMBRE_AREA
FROM PROMEDIO_MENOR am
WHERE am.ASIGNACION < (SELECT AVG(am.ASIGNACION) prom
                        FROM PROMEDIO_MENOR am)
ORDER BY am.ASIGNACION DESC



5. Se necesita saber la cantidad de clientes que hay por cada localidad 
(Tenga en cuenta en la tabla B_PERSONAS sólo aquellas que son clientes). Liste el id, la descripción de la localidad y 
la cantidad de clientes. Asegúrese que se listen también las localidades que NO tienen clientes.


SELECT L.ID ,L.NOMBRE, COUNT(P.ID)
FROM B_LOCALIDAD L
LEFT JOIN B_PERSONAS P
    ON L.ID = P.ID_LOCALIDAD AND P.ES_CLIENTE = 'S'
GROUP BY L.ID, L.NOMBRE;

6. Liste el volumen (cantidad) y monto de compras y ventas que se hicieron por cada artículo durante el año 2011. 
Debe listar también los artículos que no tuvieron movimiento. Muestre
ID, ARTICULO NOMBRE ARTICULO CANT.COMPRAS MONTO COMPRAS CANT VENTAS MONTO_VENTAS

SELECT A.ID, A.NOMBRE, SUM(DC.CANTIDAD) AS CANT_COMPRAS, SUM(DC.PRECIO_COMPRA*DC.CANTIDAD) MONTO_COMPRA, 
SUM(DV.CANTIDAD) CANT_VENTAS, SUM(DV.PRECIO*DV.CANTIDAD) MONTO_VENTAS
FROM B_ARTICULOS A
LEFT JOIN B_DETALLE_COMPRAS DC
   ON A.ID = DC.ID_ARTICULO
LEFT JOIN B_DETALLE_VENTAS DV
   ON A.ID = DV.ID_ARTICULO
GROUP BY A.ID, A.NOMBRE

