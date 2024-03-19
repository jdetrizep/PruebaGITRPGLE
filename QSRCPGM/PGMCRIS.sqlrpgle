**FREE

// ----------------------------------------------------------------- //
// PROGRAMA...: PGMGIT                                               //
// DESCRIPCIÓN: PROGRAMA PROBAR QUE GIT FUNCIONA CON AS400     //
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


// ----------------------------------------------------------------- //
//                    PROGRAMA PRINCIPAL                             //
// ----------------------------------------------------------------- //

*INLR = *ON;

// Procedimiento que se encarga de insertar en la tabla SISPROV una nueva provincia
Dcl-Proc InsertarProvincia;
    Dcl-Pi *N;
        provincia Char(50) Const;
    End-Pi;

    // Declarar variables locales
    Dcl-S sqlStmt Varchar(1000);
    Dcl-S sqlCode Int(10);

    // Construir la sentencia SQL
    sqlStmt = 'INSERT INTO SISPROV (PROVINCIA) VALUES (' + %trim(provincia) + ')';

    // Ejecutar la sentencia SQL
    //Exec SQL Execute Immediate :sqlStmt
        //Into :sqlCode;

    // Verificar el resultado de la ejecución
    If sqlCode < 0;
        // Error al ejecutar la sentencia SQL
        // Manejar el error según sea necesario
        // ...

        // Retornar un valor indicando el error
        //Return -1;
    EndIf;

    // Retornar un valor indicando éxito
    //Return 0;
End-Proc;