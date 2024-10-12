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



3. Escriba un programa que solicite al usuario ingresar un número y luego determine si el mismo es par o impar.
 Esta vez no utilice la función MOD(),hágalo por el método de división por restas sucesivas.


DECLARE
    v_contador NUMBER(10);

BEGIN
    v_contador := &v_input;

    LOOP
        v_contador := v_contador-2;
        EXIT WHEN v_contador <=0;
    END LOOP;

    IF v_contador = 0 THEN 
        DBMS_OUTPUT.PUT_LINE('Es un numero par');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Es impar');
    END IF;
END;


4. Cree un bloque PL/SQL que permita ingresar por teclado, a través de una variable de sustitución, 
la cédula de un empleado. Su programa deberá mostrar el nombre y apellido (concatenados), 
asignación y categoría del empleado

1607843
4433245

DECLARE
    v_nombre_apellido VARCHAR2(40);
    v_asignacion b_categorias_salariales.asignacion%TYPE;
    v_nombre_cat b_categorias_salariales.nombre_cat%TYPE;

BEGIN

    SELECT e.nombre ||' '|| e.apellido, cs.asignacion, cs.nombre_cat INTO v_nombre_apellido, v_asignacion, v_nombre_cat
    FROM b_empleados e
    JOIN b_posicion_actual pa
        on e.cedula = pa.cedula
    JOIN b_categorias_salariales cs
        on pa.cod_categoria = cs.cod_categoria
    WHERE pa.fecha_fin is NULL AND cs.fecha_fin is NULL AND e.cedula = &v_input_cedula;


    DBMS_OUTPUT.PUT_LINE('NOMBRE Y APELLIDO: '|| v_nombre_apellido);
    DBMS_OUTPUT.PUT_LINE('ASIGNACION: '|| v_asignacion);
    DBMS_OUTPUT.PUT_LINE('CATEGORIA: '|| v_nombre_cat);
END;


5. Cree un bloque PL/SQL que acepte por teclado el nombre de un tablespace. 
El programa deberá devolver el nombre del archivo físico (datafile) del tablespace. 
Asegúrese que lee solo el primer registro encontrado (suponiendo que el tablespace tenga más de 1 datafile).
Imprima el nombre del datafile sin el camino (PATH)