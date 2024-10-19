1. Desarrolle un PL/SQL anónimo que calcule la liquidación de salarios del mes de Agosto del 2011. El PL/SQL deberá realizar 
lo siguiente:
 Insertar un registro de cabecera de LIQUIDACIÓN correspondiente a agosto del 2011.
 Recorrer secuencialmente el archivo de empleados y calcular la liquidación de cada empleado de la siguiente manera:
salario básico = asignación correspondiente a la categoría de la posición vigente
descuento por IPS = 9,5% del salario
bonificaciónxventas= a la suma de la bonificación obtenida a partir de las ventas realizadas por ese empleado en el mes de agosto
 del 2011 (la bonificación es calculada de acuerdo a los artículos vendidos).
líquido = salario básico – descuento x IPS + bonificación (si corresponde).
 Insertar la liquidación calculada en la PLANILLA con el ID de la cabecera de liquidación creada


DECLARE
   CURSOR c_empleados IS
        SELECT e.cedula, cs.asignacion, NVL(SUM(a.precio*a.porc_comision),0) as bonificacion
        FROM b_empleados e
        JOIN b_posicion_actual pa
            on e.cedula = pa.cedula and pa.fecha_fin is null
        JOIN b_categorias_salariales cs
            on pa.cod_categoria = cs.cod_categoria and cs.fecha_fin is null
        LEFT JOIN b_ventas v
            on e.cedula = v.cedula_vendedor and EXTRACT(year from v.fecha) = 2011 and EXTRACT(MONTH from v.fecha) = 8
        LEFT JOIN b_detalle_ventas dv
            on v.id = dv.id_venta
        LEFT JOIN b_articulos a
            on dv.id_articulo = a.id
        GROUP BY e.cedula, cs.asignacion;        
BEGIN
    insert into b_liquidacion values(2,sysdate,2011,7);
   FOR r_emple IN c_empleados LOOP
        INSERT into b_planilla (id_liquidacion, cedula, salario_basico, descuento_ips, bonificacion_x_ventas, liquido_cobrado)
        values(2,r_emple.cedula, r_emple.asignacion, (0.095*r_emple.asignacion), r_emple.bonificacion, 
        (r_emple.asignacion+(0.095*r_emple.asignacion)+r_emple.bonificacion));
    END LOOP;
END;


2. Cree un bloque PL/SQL que mayorice los movimientos contables de febrero del 2012. Ud deberá
Recorrer las cuentas imputables del Plan de cuentas
Por cada cuenta, calcular el acumulado de débitos y créditos del periodo indicado
Insertar en el mayor calculando el id = id + el último id


DECLARE
    CURSOR C_CUENTAS IS 
        SELECT c.codigo_cta, dd.debe_haber, SUM(decode(dd.debe_haber,'C',dd.importe,0)) as credito, SUM(decode(dd.debe_haber,'D',dd.importe,0)) as debito
        FROM b_cuentas c
        JOIN b_diario_detalle dd
            ON c.codigo_cta = dd.codigo_cta
        WHERE extract(year from c.fecha) = 2012 and imputable = 'S'
        GROUP BY c.codigo_cta, dd.debe_haber;


3. Cree un bloque PL/SQL que haga lo siguiente:
- Declare un cursor que lea todas las localidades (B_LOCALIDAD)
- Declare el cursor C_CLIENTES que reciba como parámetro el id de la localidad, y 
que deberá obtener el monto de ventas de cada cliente de dicha localidad (PERSONAS que son clientes).
La idea es procesar el cursor sobre la localidad e imprimir el nombre de la localidad, y por cada iteración, 
abrir el cursor c_clientes e imprimir por cada cliente su Nombre y Apellido, y el monto total de ventas:

DECLARE
    CURSOR C_LOCALIDAD IS 
        SELECT * FROM b_localidad;
    CURSOR C_CLIENTES(L_ID NUMBER) IS
        SELECT p.id, p.nombre||' '||p.apellido as nombre,SUM(v.monto_total) as monto_total
        FROM b_personas p
        JOIN b_ventas v
            ON p.id = v.id_cliente and p.es_cliente = 'S'
        WHERE p.id_localidad = L_ID
        GROUP BY p.id, p.nombre||' '||p.apellido;
    v_nombre VARCHAR(40);
    v_monto NUMBER;
    v_id b_personas.id%TYPE;
BEGIN
    FOR r_local IN C_LOCALIDAD LOOP
        DBMS_OUTPUT.PUT_LINE(r_local.nombre);
        OPEN C_CLIENTES(r_local.id);
        FETCH C_CLIENTES INTO v_id, v_nombre, v_monto;
        DBMS_OUTPUT.PUT_LINE(v_nombre);
        DBMS_OUTPUT.PUT_LINE(v_monto);
        CLOSE C_CLIENTES;
    END LOOP;
END;
