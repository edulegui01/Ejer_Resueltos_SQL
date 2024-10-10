1. Cree un bloque PL/SQL anónimo que hará lo siguiente:
 Definir las variables V_MAXIMO y V_MINIMO.
 Seleccionar las asignaciones vigentes MAXIMA y MINIMA de los empleados.
 Imprimir los resultados;


DECLARE
v_maximo b_categorias_salariales.asignacion%TYPE;
v_minimo b_categorias_salariales.asignacion%TYPE;

BEGIN

SELECT MAX(CS.ASIGNACION), MIN(CS.ASIGNACION) INTO v_maximo, v_minimo
FROM b_empleados e
JOIN b_posicion_actual pa
    ON e.cedula = pa.cedula
JOIN b_categorias_salariales cs
    ON cs.cod_categoria = CS.cod_categoria
WHERE pa.fecha_fin IS NULL AND pa.fecha_fin IS NULL;


DBMS_OUTPUT.PUT_LINE('MAXIMO: '|| TO_CHAR(v_maximo) ||' '|| 'MINIMO: '|| TO_CHAR(v_minimo));

END;


2. Realice lo siguiente
 Crear la tabla SECUENCIADOR con las siguientes columnas
- NUMERO NUMBER
- VALOR_PAR VARCHAR2(30)
- VALOR_IMPAR
 Desarrolle un PL/SQL anónimo que permita insertar 100 filas. 
En la primera columna se insertará el valor del contador y en la segunda y tercera columnas, 
el número concatenado con la expresión “es par” o “es impar” según sea par o impar. Utilice la función MOD.


CREATE TABLE secuenciador(
    numero number(2),
    valor_par VARCHAR2(30),
    valor_impar VARCHAR2(30));


BEGIN
    FOR i IN 1..50 LOOP
        IF MOD(i,2) = 0 THEN INSERT INTO secuenciador(numero, valor_par) VALUEs(i,'es par');
        ELSE  INSERT INTO secuenciador(numero, valor_par) VALUEs(i,'es par');
        END IF;
    END LOOP;
    COMMIT;
END;


BEGIN
    FOR i IN 1..50 LOOP
        IF MOD(i,2) = 0 THEN INSERT INTO secuenciador(numero, valor_par) VALUEs(i,'es par');
        ELSE  INSERT INTO secuenciador(numero, valor_par) VALUEs(i,'es impar');
        END IF;
    END LOOP;
    COMMIT;
END;