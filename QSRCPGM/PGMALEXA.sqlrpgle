**FREE

// ----------------------------------------------------------------- //
// PROGRAMA...: PGMALEXA                                             //
// DESCRIPCIÓN: PROGRAMA PROBAR QUE GIT FUNCIONA CON AS400           //
// AUTOR......: JORGE DE TRINIDAD ZEPEDA NOVACOMP S.A.               //
// FECHA......: NOVIEMBRE 2023.                                      //
// ----------------------------------------------------------------- //

// ----------------------------------------------------------------- //
//         ESPECIFICACIONES DE ENCABEZADO                            //
// ----------------------------------------------------------------- //

CTL-OPT DATFMT(*ISO);
CTL-OPT COPYRIGHT('Copyright NovaTalentos 2023');
CTL-OPT DEBUG(*YES);
CTL-OPT DFTACTGRP(*NO) ACTGRP(*CALLER);
CTL-OPT BNDDIR('SERVICEBCO');

// ----------------------------------------------------------------- //
//                    DEFINICIÓN DE ARCHIVOS                         //
// ----------------------------------------------------------------- //


// ----------------------------------------------------------------- //
//                    ESTRUCTURAS DE DATOS                           //
// ----------------------------------------------------------------- //


// ----------------------------------------------------------------- //
//                    VARIABLES GLABALES                             //
// ----------------------------------------------------------------- //
dcl-s vNumero	ZONED(10:0) Inz(*ZEROS);
dcl-s vNumero2	ZONED(10:0) Inz(*ZEROS);
dcl-s vResultado	ZONED(10:0) Inz(*ZEROS);

// ----------------------------------------------------------------- //
//                    PROGRAMA PRINCIPAL                             //
// ----------------------------------------------------------------- //

vNumero = 10;
vNumero2 = 20;

vResultado = Suma(vNumero:vNumero2);
*INLR = *ON;

//Procedimiento para realizar el caluclo de la suma de dos números
Dcl-Proc Suma export;
    Dcl-Pi *N ZONED(10:0);
        a ZONED(10:0) Const;
        b ZONED(10:0) Const;
    End-Pi;

    Dcl-S c ZONED(10:0);

    c = a + b;

    Return c;
End-Proc;

