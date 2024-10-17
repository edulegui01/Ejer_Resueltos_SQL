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



6. Cree un bloque PL/SQL que dada una variable alfanumérica (cuyo valor deberá ingresarse por teclado).
Deberá imprimir dicha variable tal como se la introdujo, y posteriormente intercambiada. Ejemplo:}
 Si intruduce ‘123456’ deberá mostrar en pantalla ‘654321’ :


 DECLARE
 v_delrevez VARCHAR(20) := '';
 v_longitud NUMBER;
 v_cadena VARCHAR(20);
 BEGIN
    v_cadena:='&v_input_cadena';
    v_longitud:=LENGTH(v_cadena);

    WHILE v_longitud>=1 LOOP
        v_delrevez:= v_delrevez||SUBSTR(v_cadena,v_longitud,1);
        v_longitud:=v_longitud-1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(v_cadena);
    DBMS_OUTPUT.PUT_LINE(v_delrevez);
END;

8. Desarrolle un bloque PL/SQL anónimo que permita leer un número y posteriormente informar si el mismo es palíndromo o no. 
Un palíndromo es un número que se lee igual de izquierda a derecha y de derecha a izquierda. 
Ejemplos: 161, 2992, 3003, 2882, 5005, 292.


DECLARE
    v_numero VARCHAR(20);
    v_longitud NUMBER;
    v_numero_revez VARCHAR(20);
BEGIN
    v_numero:=&v_input_numero;
    v_longitud:=LENGTH(v_numero)+1;
    FOR i IN 1..(v_longitud-1) LOOP
        v_numero_revez:=v_numero_revez||SUBSTR(v_numero,v_longitud-i,1);
    END LOOP;
    IF v_numero=v_numero_revez THEN
        DBMS_OUTPUT.PUT_LINE('ES PALINDROMO');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NO ES PALINDROMO');
    END IF;
END;

9. Cree un bloque PL/SQL que por teclado la cédula de un empleado. El PL/SQL deberá devolver el monto de ventas
 que tuvo ese empleado en el año 2011. Posteriormente deberá calcular la calificación de sus ventas: si el monto
  calculado es menor que 3.000.000, deberá imprimir: “REGULAR”. Si el monto es mayor que 3.000.000 y menor que 10.000.000 
  imprima “BUENO”, y si es superior a 10.000.000 imprima “EXCELENTE”.

DECLARE
    v_empleado VARCHAR(30);
    v_monto b_ventas.monto_total%TYPE;
    v_cedula b_empleados.cedula%TYPE;
BEGIN
    SELECT e.cedula, e.nombre||' '||e.apellido, SUM(v.monto_total) INTO v_cedula, v_empleado, v_monto
    FROM b_ventas v
    JOIN b_empleados e
        on v.cedula_vendedor = e.cedula
    WHERE e.cedula = &v_input_cedula AND EXTRACT(YEAR FROM v.fecha) = 2011
    GROUP BY e.cedula, e.nombre, e.apellido;

    IF v_monto<3000000 THEN
        DBMS_OUTPUT.PUT_LINE(v_cedula||' '||v_empleado||' '||v_monto||' VENTA REGULAR');
    ELSIF v_monto<10000000 THEN
        DBMS_OUTPUT.PUT_LINE(v_cedula||' '||v_empleado||' '||v_monto||' VENTA BUENA');
    ELSIF v_monto>10000000 THEN
        DBMS_OUTPUT.PUT_LINE(v_cedula||' '||v_empleado||' '||v_monto||' VENTA EXCELENTE');
    END IF;
END;


10. Escriba un bloque PL/SQL anónimo que resuelva una ecuación de segundo grado ingresando por teclado los valores 
de A, B y C. Si el discriminante de la ecuación es menor a cero debe imprimir el mensaje 
"no tiene solución en el conjunto de los números reales”. Si el discriminante es 0, 
tiene una solución real, caso contrario (> 0), tiene 2 soluciones, X1 y X2, y en este caso, 
deberá imprimir los valores de X1 y X2.
Datos de interés:"


DECLARE
    v_a NUMBER;
    v_b NUMBER;
    v_c NUMBER;
    v_discriminante NUMBER;
    v_solucion NUMBER;
BEGIN
    v_a:=&v_input_a;
    v_b:=&v_input_b;
    v_c:=&v_input_c;
    v_discriminante:=POWER(v_b,2)-(4*v_a*v_c);

    IF v_discriminante<0 THEN
        DBMS_OUTPUT.PUT_LINE('NO TIENE SOLUCION REAL');
    ELSIF v_discriminante=0 THEN
        DBMS_OUTPUT.PUT_LINE('TIENE UNA SOLUCION REAL');
    ELSE
        v_solucion:=((v_b*-1)+SQRT(v_discriminante))/(2*v_a);
        DBMS_OUTPUT.PUT_LINE('X1: '||v_solucion);
        DBMS_OUTPUT.PUT_LINE('X2: '||(v_solucion*-1));
    END IF;
END;



DECLARE
   num_input NUMBER;    -- Variable para almacenar el número ingresado por el usuario
   temp_num  NUMBER;    -- Variable temporal para manipular el número
   factor    NUMBER := 1;   -- Factor de multiplicación para determinar el valor posicional
   digit     NUMBER;    -- Variable para almacenar cada dígito
BEGIN
   -- Solicitar al usuario que ingrese un número entero positivo
   num_input := &Ingrese; -- Usa '&' para pedir el valor al usuario en SQL*Plus
   
   -- Inicializar la variable temporal con el número ingresado
   temp_num := num_input;
   
   -- Calcular el factor más grande que será utilizado (la posición más alta del número)
   WHILE temp_num >= 10 LOOP
      factor := factor * 10;
      temp_num := temp_num / 10;
   END LOOP;

   -- Volver a inicializar la variable temporal con el número original
   temp_num := num_input;

   -- Descomponer el número
   WHILE factor > 0 LOOP
      digit := TRUNC(temp_num / factor);  -- Obtener el dígito en la posición actual
      
      IF digit <> 0 THEN
         DBMS_OUTPUT.PUT_LINE(digit * factor);  -- Imprimir el valor posicional
      END IF;
      
      temp_num := MOD(temp_num, factor);  -- Quitar el dígito más significativo
      factor := factor / 10;  -- Reducir el factor para pasar a la siguiente posición
   END LOOP;
END;