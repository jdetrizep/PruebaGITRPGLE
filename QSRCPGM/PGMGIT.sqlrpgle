**FREE

// ----------------------------------------------------------------- //
// PROGRAMA...: PGMGIT                                               //
// DESCRIPCIÓN: PROGRAMA PRUEBA GIT FUNCIONA CON AS400               //
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
dcl-s vVerdad IND INZ(*OFF);

// ----------------------------------------------------------------- //
//                    PROGRAMA PRINCIPAL                             //
// ----------------------------------------------------------------- //

// Validamos el Flujo del Usuario
DOW *IN03 = *OFF;

  if (vVerdad = *ON);
    //PONER CODIGO LISTO
  else;
   //EN CASO DE ERROR
  endif;

// Se finaliza el ciclo para la prueba
  *IN03 = *ON;
ENDDO;

*INLR = *ON;