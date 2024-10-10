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







