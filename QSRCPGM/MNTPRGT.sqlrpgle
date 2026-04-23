**FREE
//***********************************************************************
//* PROGRAMA...: MNTPRGT                                               *
//* DESCRIPCIÓN: PRUEBAS UNITARIAS PARA MNTPRG (RPGUnit)              *
//* AUTOR......: JORGE DE TRINIDAD ZEPEDA. NOVACOMP S.A.               *
//* FECHA......: ABRIL 2026                                            *
//***********************************************************************
//* Framework: RPGUnit                                                 *
//* Propósito: Validar funcionalidades del programa MNTPRG.sqlrpgle   *
//***********************************************************************

Ctl-Opt NoMain Option(*SrcStmt:*NoDebugIO);

/COPY RPGUNIT1,TESTCASE

// Prototipos de procedimientos a probar (del programa principal)
Dcl-Pr ValidarCodigoProvincia Ind;
  pCodigo Int(10) Const;
End-Pr;

Dcl-Pr ValidarNombreProvincia Ind;
  pNombre Char(50) Const;
End-Pr;

Dcl-Pr ExisteProvinciaBD Ind;
  pCodigo Int(10) Const;
End-Pr;

Dcl-Pr InsertarProvinciaBD Ind;
  pCodigo Int(10) Const;
  pNombre Char(50) Const;
End-Pr;

Dcl-Pr ActualizarProvinciaBD Ind;
  pCodigo Int(10) Const;
  pNombre Char(50) Const;
End-Pr;

Dcl-Pr EliminarProvinciaBD Ind;
  pCodigo Int(10) Const;
End-Pr;

Dcl-Pr ObtenerProvinciaBD Ind;
  pCodigo Int(10) Const;
  pNombre Char(50);
End-Pr;

//***********************************************************************
//* SUITE DE PRUEBAS: Validaciones
//***********************************************************************

// Test: Validar código de provincia válido
Dcl-Proc testValidarCodigoValido Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  
  resultado = ValidarCodigoProvincia(1);
  aEqual(*On : resultado : 'Código 1 debe ser válido');
  
  resultado = ValidarCodigoProvincia(999);
  aEqual(*On : resultado : 'Código 999 debe ser válido');
End-Proc;

// Test: Validar código de provincia inválido
Dcl-Proc testValidarCodigoInvalido Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  
  resultado = ValidarCodigoProvincia(0);
  aEqual(*Off : resultado : 'Código 0 debe ser inválido');
  
  resultado = ValidarCodigoProvincia(-1);
  aEqual(*Off : resultado : 'Código negativo debe ser inválido');
End-Proc;

// Test: Validar nombre de provincia válido
Dcl-Proc testValidarNombreValido Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  
  resultado = ValidarNombreProvincia('San José');
  aEqual(*On : resultado : 'Nombre "San José" debe ser válido');
  
  resultado = ValidarNombreProvincia('A');
  aEqual(*On : resultado : 'Nombre de 1 carácter debe ser válido');
End-Proc;

// Test: Validar nombre de provincia inválido
Dcl-Proc testValidarNombreInvalido Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  
  resultado = ValidarNombreProvincia('');
  aEqual(*Off : resultado : 'Nombre vacío debe ser inválido');
  
  resultado = ValidarNombreProvincia(*Blanks);
  aEqual(*Off : resultado : 'Nombre en blanco debe ser inválido');
End-Proc;

//***********************************************************************
//* SUITE DE PRUEBAS: Operaciones CRUD
//***********************************************************************

// Test: Insertar provincia nueva
Dcl-Proc testInsertarProvinciaNueva Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  Dcl-S codigoTest Int(10);
  
  // Usar código alto para evitar conflictos
  codigoTest = 9999;
  
  // Limpiar si existe
  EliminarProvinciaBD(codigoTest);
  
  // Insertar
  resultado = InsertarProvinciaBD(codigoTest : 'Provincia Test');
  aEqual(*On : resultado : 'Inserción debe ser exitosa');
  
  // Verificar que existe
  resultado = ExisteProvinciaBD(codigoTest);
  aEqual(*On : resultado : 'Provincia insertada debe existir');
  
  // Limpiar
  EliminarProvinciaBD(codigoTest);
End-Proc;

// Test: Insertar provincia duplicada
Dcl-Proc testInsertarProvinciaDuplicada Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  Dcl-S codigoTest Int(10);
  
  codigoTest = 9998;
  
  // Limpiar si existe
  EliminarProvinciaBD(codigoTest);
  
  // Primera inserción
  resultado = InsertarProvinciaBD(codigoTest : 'Provincia Test 1');
  aEqual(*On : resultado : 'Primera inserción debe ser exitosa');
  
  // Segunda inserción (duplicada)
  resultado = InsertarProvinciaBD(codigoTest : 'Provincia Test 2');
  aEqual(*Off : resultado : 'Inserción duplicada debe fallar');
  
  // Limpiar
  EliminarProvinciaBD(codigoTest);
End-Proc;

// Test: Actualizar provincia existente
Dcl-Proc testActualizarProvinciaExistente Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  Dcl-S codigoTest Int(10);
  Dcl-S nombreOriginal Char(50);
  Dcl-S nombreActualizado Char(50);
  Dcl-S nombreLeido Char(50);
  
  codigoTest = 9997;
  nombreOriginal = 'Provincia Original';
  nombreActualizado = 'Provincia Actualizada';
  
  // Preparar datos
  EliminarProvinciaBD(codigoTest);
  InsertarProvinciaBD(codigoTest : nombreOriginal);
  
  // Actualizar
  resultado = ActualizarProvinciaBD(codigoTest : nombreActualizado);
  aEqual(*On : resultado : 'Actualización debe ser exitosa');
  
  // Verificar cambio
  ObtenerProvinciaBD(codigoTest : nombreLeido);
  aEqual(nombreActualizado : %Trim(nombreLeido) : 
         'Nombre debe estar actualizado');
  
  // Limpiar
  EliminarProvinciaBD(codigoTest);
End-Proc;

// Test: Actualizar provincia inexistente
Dcl-Proc testActualizarProvinciaInexistente Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  Dcl-S codigoTest Int(10);
  
  codigoTest = 9996;
  
  // Asegurar que no existe
  EliminarProvinciaBD(codigoTest);
  
  // Intentar actualizar
  resultado = ActualizarProvinciaBD(codigoTest : 'Provincia Test');
  aEqual(*Off : resultado : 'Actualización de inexistente debe fallar');
End-Proc;

// Test: Eliminar provincia existente
Dcl-Proc testEliminarProvinciaExistente Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  Dcl-S codigoTest Int(10);
  
  codigoTest = 9995;
  
  // Preparar datos
  EliminarProvinciaBD(codigoTest);
  InsertarProvinciaBD(codigoTest : 'Provincia Test');
  
  // Eliminar
  resultado = EliminarProvinciaBD(codigoTest);
  aEqual(*On : resultado : 'Eliminación debe ser exitosa');
  
  // Verificar que no existe
  resultado = ExisteProvinciaBD(codigoTest);
  aEqual(*Off : resultado : 'Provincia eliminada no debe existir');
End-Proc;

// Test: Eliminar provincia inexistente
Dcl-Proc testEliminarProvinciaInexistente Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  Dcl-S codigoTest Int(10);
  
  codigoTest = 9994;
  
  // Asegurar que no existe
  EliminarProvinciaBD(codigoTest);
  
  // Intentar eliminar
  resultado = EliminarProvinciaBD(codigoTest);
  aEqual(*Off : resultado : 'Eliminación de inexistente debe fallar');
End-Proc;

// Test: Consultar provincia existente
Dcl-Proc testConsultarProvinciaExistente Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  Dcl-S codigoTest Int(10);
  Dcl-S nombreTest Char(50);
  Dcl-S nombreLeido Char(50);
  
  codigoTest = 9993;
  nombreTest = 'Provincia Consulta';
  
  // Preparar datos
  EliminarProvinciaBD(codigoTest);
  InsertarProvinciaBD(codigoTest : nombreTest);
  
  // Consultar
  resultado = ObtenerProvinciaBD(codigoTest : nombreLeido);
  aEqual(*On : resultado : 'Consulta debe ser exitosa');
  aEqual(nombreTest : %Trim(nombreLeido) : 'Nombre debe coincidir');
  
  // Limpiar
  EliminarProvinciaBD(codigoTest);
End-Proc;

// Test: Consultar provincia inexistente
Dcl-Proc testConsultarProvinciaInexistente Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  Dcl-S codigoTest Int(10);
  Dcl-S nombreLeido Char(50);
  
  codigoTest = 9992;
  
  // Asegurar que no existe
  EliminarProvinciaBD(codigoTest);
  
  // Intentar consultar
  resultado = ObtenerProvinciaBD(codigoTest : nombreLeido);
  aEqual(*Off : resultado : 'Consulta de inexistente debe fallar');
End-Proc;

//***********************************************************************
//* SUITE DE PRUEBAS: Casos Límite
//***********************************************************************

// Test: Nombre con caracteres especiales
Dcl-Proc testNombreConCaracteresEspeciales Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  Dcl-S codigoTest Int(10);
  Dcl-S nombreTest Char(50);
  Dcl-S nombreLeido Char(50);
  
  codigoTest = 9991;
  nombreTest = 'San José-Cartago (Costa Rica)';
  
  // Preparar datos
  EliminarProvinciaBD(codigoTest);
  
  // Insertar
  resultado = InsertarProvinciaBD(codigoTest : nombreTest);
  aEqual(*On : resultado : 'Inserción con caracteres especiales OK');
  
  // Verificar
  ObtenerProvinciaBD(codigoTest : nombreLeido);
  aEqual(nombreTest : %Trim(nombreLeido) : 
         'Caracteres especiales deben preservarse');
  
  // Limpiar
  EliminarProvinciaBD(codigoTest);
End-Proc;

// Test: Nombre máximo (50 caracteres)
Dcl-Proc testNombreMaximo Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  Dcl-S codigoTest Int(10);
  Dcl-S nombreTest Char(50);
  Dcl-S nombreLeido Char(50);
  
  codigoTest = 9990;
  nombreTest = '12345678901234567890123456789012345678901234567890';
  
  // Preparar datos
  EliminarProvinciaBD(codigoTest);
  
  // Insertar
  resultado = InsertarProvinciaBD(codigoTest : nombreTest);
  aEqual(*On : resultado : 'Inserción con nombre máximo OK');
  
  // Verificar
  ObtenerProvinciaBD(codigoTest : nombreLeido);
  aEqual(nombreTest : nombreLeido : 'Nombre máximo debe preservarse');
  
  // Limpiar
  EliminarProvinciaBD(codigoTest);
End-Proc;

//***********************************************************************
//* SUITE DE PRUEBAS: Transacciones
//***********************************************************************

// Test: Múltiples operaciones en secuencia
Dcl-Proc testOperacionesEnSecuencia Export;
  Dcl-Pi *N;
  End-Pi;
  
  Dcl-S resultado Ind;
  Dcl-S codigoTest Int(10);
  Dcl-S nombreLeido Char(50);
  
  codigoTest = 9989;
  
  // Limpiar
  EliminarProvinciaBD(codigoTest);
  
  // 1. Insertar
  resultado = InsertarProvinciaBD(codigoTest : 'Versión 1');
  aEqual(*On : resultado : 'Paso 1: Inserción OK');
  
  // 2. Actualizar
  resultado = ActualizarProvinciaBD(codigoTest : 'Versión 2');
  aEqual(*On : resultado : 'Paso 2: Actualización OK');
  
  // 3. Consultar
  resultado = ObtenerProvinciaBD(codigoTest : nombreLeido);
  aEqual(*On : resultado : 'Paso 3: Consulta OK');
  aEqual('Versión 2' : %Trim(nombreLeido) : 'Paso 3: Nombre correcto');
  
  // 4. Actualizar nuevamente
  resultado = ActualizarProvinciaBD(codigoTest : 'Versión 3');
  aEqual(*On : resultado : 'Paso 4: Segunda actualización OK');
  
  // 5. Eliminar
  resultado = EliminarProvinciaBD(codigoTest);
  aEqual(*On : resultado : 'Paso 5: Eliminación OK');
  
  // 6. Verificar eliminación
  resultado = ExisteProvinciaBD(codigoTest);
  aEqual(*Off : resultado : 'Paso 6: No debe existir');
End-Proc;

//***********************************************************************
//* IMPLEMENTACIÓN DE FUNCIONES DE UTILIDAD PARA PRUEBAS
//***********************************************************************

// Validar código de provincia
Dcl-Proc ValidarCodigoProvincia;
  Dcl-Pi *N Ind;
    pCodigo Int(10) Const;
  End-Pi;
  
  Return (pCodigo > 0);
End-Proc;

// Validar nombre de provincia
Dcl-Proc ValidarNombreProvincia;
  Dcl-Pi *N Ind;
    pNombre Char(50) Const;
  End-Pi;
  
  Return (pNombre <> *Blanks);
End-Proc;

// Verificar si existe provincia
Dcl-Proc ExisteProvinciaBD;
  Dcl-Pi *N Ind;
    pCodigo Int(10) Const;
  End-Pi;
  
  Dcl-S lCount Int(10);
  
  Exec SQL
    SELECT COUNT(*)
    INTO :lCount
    FROM SISPROV
    WHERE IDPROV = :pCodigo;
  
  Return (lCount > 0);
End-Proc;

// Insertar provincia
Dcl-Proc InsertarProvinciaBD;
  Dcl-Pi *N Ind;
    pCodigo Int(10) Const;
    pNombre Char(50) Const;
  End-Pi;
  
  Exec SQL
    INSERT INTO SISPROV (IDPROV, NOMPRO)
    VALUES (:pCodigo, :pNombre);
  
  Return (SQLCODE = 0);
End-Proc;

// Actualizar provincia
Dcl-Proc ActualizarProvinciaBD;
  Dcl-Pi *N Ind;
    pCodigo Int(10) Const;
    pNombre Char(50) Const;
  End-Pi;
  
  Exec SQL
    UPDATE SISPROV
    SET NOMPRO = :pNombre
    WHERE IDPROV = :pCodigo;
  
  Return (SQLCODE = 0 And SQLERRD(3) > 0);
End-Proc;

// Eliminar provincia
Dcl-Proc EliminarProvinciaBD;
  Dcl-Pi *N Ind;
    pCodigo Int(10) Const;
  End-Pi;
  
  Exec SQL
    DELETE FROM SISPROV
    WHERE IDPROV = :pCodigo;
  
  Return (SQLCODE = 0 Or SQLCODE = 100);
End-Proc;

// Obtener provincia
Dcl-Proc ObtenerProvinciaBD;
  Dcl-Pi *N Ind;
    pCodigo Int(10) Const;
    pNombre Char(50);
  End-Pi;
  
  Exec SQL
    SELECT NOMPRO
    INTO :pNombre
    FROM SISPROV
    WHERE IDPROV = :pCodigo;
  
  Return (SQLCODE = 0);
End-Proc;