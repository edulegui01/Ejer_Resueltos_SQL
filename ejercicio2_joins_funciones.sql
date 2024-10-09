El campo FILE_NAME del archivo DBA_DATA_FILES contiene el nombre y camino de los archivos físicos que 
conforman los espacios de tabla de la Base de Datos. Seleccione:
-Solamente el nombre del archivo (sin mencionar la carpeta o camino):
-Solamente la carpeta o caminino (sin mencionar el archivo)

select substr(file_name,INSTR(file_name,'\',-1)+1) from dba_data_files;
select substr(file_name,1,INSTR(file_name,'\',-1)-1) from dba_data_files;






Obtenga la lista de empleados con su posición y salario vigente (El salario y la categoría vigente tienen la fecha fin nula – 
Un solo salario está vigente en un momento dado). Debe listar:
Nombre área, Apellido y nombre del empleado, Fecha Ingreso, categoría, salario actual
La lista debe ir ordenada por nombre de área, y por apellido del funcionario.

SELECT A.NOMBRE_AREA, E.NOMBRE ||' '|| E.APELLIDO AS EMPLEADO, E.FECHA_ING, CS.NOMBRE_CAT, CS.ASIGNACION, CS.FECHA_FIN 
FROM B_EMPLEADOS E
JOIN B_POSICION_ACTUAL PA
    ON E.CEDULA = PA.CEDULA
JOIN B_AREAS A
    ON PA.ID_AREA = A.ID
JOIN B_CATEGORIAS_SALARIALES CS
    ON PA.COD_CATEGORIA = CS.COD_CATEGORIA
ORDER BY EMPLEADO;


Liste el libro DIARIO correspondiente al mes de enero del año 2012, tomando en cuenta la cabecera y
 el detalle. Debe listar los siguientes datos:
ID_Asiento, Fecha, Concepto, Nro.Linea, código cuenta, nombre cuenta, Monto débito, Monto crédito 
(haga aparecer el monto del crédito o débito según el valor del campo débito_crédito – D ó C)


SELECT DC.ID, DC.FECHA, DC.CONCEPTO, DD.NRO_LINEA, DD.CODIGO_CTA, C.NOMBRE_CTA, M.ACUM_DEBITO AS D, M.ACUM_CREDITO AS C
FROM B_DIARIO_CABECERA DC
JOIN B_DIARIO_DETALLE DD
    ON DC.ID = DD.ID
JOIN B_CUENTAS C
    ON DD.CODIGO_CTA = C.CODIGO_CTA
JOIN B_MAYOR M
    ON C.CODIGO_CTA = M.CODIGO_CTA
WHERE EXTRACT(YEAR FROM DC.FECHA_CIERRE) = 2012



Algunos empleados de la empresa son también clientes. Obtenga dicha lista a través de una operación de intersección. 
Liste cédula, nombre y apellido, teléfono. 
Tenga en cuenta sólo a las personas físicas (F) que tengan cédula. 
Recuerde que los tipos de datos para operaciones del álgebra relacional tienen que ser los mismos.


SELECT TO_CHAR(CEDULA), NOMBRE, APELLIDO, TELEFONO
FROM B_EMPLEADOS
INTERSECT
SELECT CEDULA, NOMBRE, APELLIDO, TELEFONO
FROM B_PERSONAS
WHERE TIPO_PERSONA = 'F';


Se pretende realizar el aumento salarial del 5% para todas las categorías. 
Debe listar la categoría (código y nombre), el importe actual, el importe aumentado al 5% (redondeando la cifra a la centena), 
y la diferencia.
Formatee la salida (usando TO_CHAR) para que los montos tengan los puntos de mil.


SELECT COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, ROUND(ASIGNACION+(ASIGNACION*0.05), - 2) AS IMPORTE_AUMENTADO, 
(ASIGNACION*0.05) AS DIFERENCIA
FROM B_CATEGORIAS_SALARIALES;



Se necesita tener la lista completa de personas (independientemente de su tipo), ordenando por nombre de localidad. 
Si la persona no tiene asignada una localidad, también debe aparecer. 
Liste Nombre de Localidad, Nombre y apellido de la persona, dirección, teléfono


SELECT NVL(L.NOMBRE, 'NO TIENE LOCALIDAD') AS LOCALIDAD, P.NOMBRE ||' '|| P.APELLIDO AS NOMBRE, P.DIRECCION, P.TELEFONO
FROM B_PERSONAS P
LEFT JOIN B_LOCALIDAD L
    ON P.ID_LOCALIDAD = L.ID

SELECT NVL(L.NOMBRE, 'NO TIENE LOCALIDAD') AS LOCALIDAD, P.NOMBRE ||' '|| P.APELLIDO AS NOMBRE, P.DIRECCION, P.TELEFONO
FROM B_PERSONAS P
RIGHT JOIN B_LOCALIDAD L
    ON P.ID_LOCALIDAD = L.ID

SELECT NVL(L.NOMBRE, 'NO TIENE LOCALIDAD') AS LOCALIDAD, P.NOMBRE ||' '|| P.APELLIDO AS NOMBRE, P.DIRECCION, P.TELEFONO
FROM B_PERSONAS P
FULL JOIN B_LOCALIDAD L
    ON P.ID_LOCALIDAD = L.ID



Considerando la fecha de hoy, indique cuándo caerá el próximo DOMINGO.


SELECT NEXT_DAY(SYSDATE,'DOMINGO')FROM DUAL;


Utilice la función LAST_DAY para determinar si este año es bisiesto o no. 
Con CASE y con DECODE, haga aparecer la expresión ‘bisiesto’ o ‘no bisiesto’ según corresponda. 
(En un año bisiesto el mes de febrero tiene 29 días)


select  CASE last_day('01-FEB-24') 
WHEN TO_DATE('29-FEB-24') THEN 'ES UN ANHO BISIESTO'
ELSE 'NO ES UN ANHO BISIESTO'
END "FASFA"
from dual;


SELECT DECODE(last_day('01-FEB-23'),TO_DATE('29-FEB-24'),'ES UN ANHO BISIESTO','NO ES UN ANHO BISIESTO')
FROM DUAL;



Tomando en cuenta la fecha de hoy, verifique que fecha dará redondeando al año? Y truncando al año? 
Escriba el resultado. Pruebe lo mismo suponiendo que sea el 1 de Julio del año. Pruebe también el 12 de marzo.


SELECT ROUND(SYSDATE,'YEAR') FROM DUAL;
SELECT TRUNC(SYSDATE,'YEAR') FROM DUAL;


SELECT ROUND(TO_DATE('01-JUL-24'),'YEAR') FROM DUAL;
SELECT TRUNC(TO_DATE('01-JUL-24'),'YEAR') FROM DUAL;

SELECT ROUND(TO_DATE('12-MAR-24'),'YEAR') FROM DUAL;
SELECT TRUNC(TO_DATE('12-MAR-24'),'YEAR') FROM DUAL;


Imprima su edad en años y meses. Ejemplo: Si nació el 23/abril/1972, tendría 43 años y 3 meses a la fecha.


SELECT 
    TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE('14/04/1993', 'DD/MM/YYYY')) / 12) AS anhs,
    TRUNC(MOD(MONTHS_BETWEEN(SYSDATE, TO_DATE('14/04/1993', 'DD/MM/YYYY')), 12)) AS meses
FROM 
    dual;


Determine la fecha y hora del sistema en el formato apropiado.


select TO_CHAR(SYSDATE,'DD/MM/YYYY') FROM DUAL;


Liste ID y NOMBRE de todos los artículos que no están incluidos en ninguna VENTA. Debe utilizar necesariamente la sentencia MINUS.

SELECT A.ID, A.NOMBRE
FROM B_ARTICULOS A
LEFT JOIN B_DETALLE_VENTAS DV
    ON A.ID = DV.ID_ARTICULO
MINUS
SELECT A.ID, A.NOMBRE
FROM B_ARTICULOS A
JOIN B_DETALLE_VENTAS DV
    ON A.ID = DV.ID_ARTICULO



La organización ha decidido mantener un registro único de todas las personas, sean éstas proveedores, 
clientes y/o empleados. Para el efecto se le pide una operación de UNION entre las tablas de B_PERSONAS y 
B_EMPLEADOS. Debe listar
CEDULA, APELLIDO, NOMBRE, DIRECCION, TELEFONO, FECHA_NACIMIENTO.
En la tabla PERSONAS tenga únicamente en cuenta las personas de tipo FISICAS (F) y que tengan cédula. 
Ordene la consulta por apellido y nombre


SELECT CEDULA, APELLIDO, NOMBRE, DIRECCION, TELEFONO, FECHA_NACIMIENTO
FROM B_PERSONAS P
WHERE TIPO_PERSONA = 'F' AND CEDULA IS NOT NULL;
UNION
SELECT CEDULA, APELLIDO, NOMBRE, DIRECCION,TELEFONO, FECHA_NACIM
FROM B_EMPLEADOS
ORDER BY APELLIDO, NOMBRE;



El área de CREDITOS Y COBRANZAS solicita un informe de las ventas a crédito efectuadas en el año 2018 y 
cuyas cuotas tienen atraso en el pago. A las cuotas que se encuentran en dicha situación se le aplica una tasa 
de interés del 0.5% por cada día de atraso.
Se considera que una cuota está en mora cuando ya pasó la fecha de vencimiento y no 
existe aún pago alguno. Se pide mostrar los siguientes datos y ordenar de forma descendente por días de atraso.


SELECT V.NUMERO_FACTURA, E.NOMBRE ||' '|| E.APELLIDO AS EMPLEADO, 
DECODE(P.TIPO_PERSONA,'F',P.CEDULA,'J',P.RUC,'NO TIENE DOCUMENTO') AS RUC_CI, P.NOMBRE ||' '|| P.APELLIDO AS CLIENTE,
PP.NUMERO_CUOTA AS CUOTA, PP.VENCIMIENTO, PP.MONTO_CUOTA, TRUNC(PP.VENCIMIENTO-SYSDATE)*-1 AS "DIAS DE ATRASO",
TO_CHAR(ROUND((PP.MONTO_CUOTA*(0.05/100)*TRUNC(PP.VENCIMIENTO-SYSDATE)*-1)),'999G999G999') AS "INTERES",
TO_CHAR(ROUND(PP.MONTO_CUOTA+(PP.MONTO_CUOTA*(0.05/100)*TRUNC(PP.VENCIMIENTO-SYSDATE)*-1)),'999G999G999') AS "MONTO A PAGAR"
FROM B_VENTAS V
JOIN B_PERSONAS P
    ON V.ID_CLIENTE = P.ID
JOIN B_EMPLEADOS E
    ON V.CEDULA_VENDEDOR = E.CEDULA
JOIN B_PLAN_PAGO PP
    ON V.ID = PP.ID_VENTA
WHERE PP.FECHA_PAGO IS NULL;



El Dpto. Financiero de la empresa necesita un informe de los movimientos correspondientes a
compras y ventas efectuadas en el primer semestre del año 2011.
El informe debe contener:
 Fecha de la operación.
 Concepto: Para obtener esta columna debe concatenar las expresiones y/o campos:
 Operación: Venta o Compra de mercaderías según factura.
 Tipo de Factura: Contado o Crédito.
 Factura: para obtener el formato Nº 000-000-0000000, debe concatenar el número '001' +
el id de la localidad del proveedor o cliente + el número de factura.
Recuerde rellenar con ceros hasta alcanzar la cantidad de caracteres establecidos para
cada grupo. Ejemplos:
'VENTA DE MERCADERÍAS SEGÚN FACTURA CONTADO Nº 001-002-0003264'
'COMPRA DE MERCADERÍAS SEGÚN FACTURA CREDITO Nº 001-002-0003264'  Monto Débito: Si es una compra se coloca el monto de 
la operación, pero si es una venta se coloca 0.  Monto Crédito: 
Si es una venta se coloca el monto de la operación, pero si es una compra se coloca 0. 
Por último, se pide que ordene los registros por la fecha en forma ascendente.


(SELECT FECHA, 'COMPRAS DE MERCADERIAS '|| '001-'|| LPAD(P.ID_LOCALIDAD,3,'0')|| '-'||LPAD(C.ID_CONDICION,7,'0') AS CONCEPTO,
C.MONTO_TOTAL AS "MONTO DEBITO", 0 AS "MONTO CREDITO"
FROM B_COMPRAS C
JOIN B_PERSONAS P
    ON C.ID_PROVEEDOR = P.ID)
UNION
(SELECT FECHA, 'VENTAS DE MERCADERIAS '|| '001-'|| LPAD(P.ID_LOCALIDAD,3,'0')|| '-'||LPAD(V.NUMERO_FACTURA,7,'0') AS CONCEPTO,
0 AS "MONTO DEBITO", V.MONTO_TOTAL AS "MONTO CREDITO"
FROM B_VENTAS V
JOIN B_PERSONAS P
    ON V.ID_CLIENTE = P.ID)
ORDER BY FECHA DESC


