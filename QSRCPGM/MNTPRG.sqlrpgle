**FREE
//***********************************************************************
//* PROGRAMA...: MANTPRO                                               *
//* DESCRIPCIÓN: PROGRAMA DE MANTENIMIENTO DE PROVINCIAS (MODERNIZADO)*
//* AUTOR......: JORGE DE TRINIDAD ZEPEDA. NOVACOMP S.A.               *
//* FECHA......: JUNIO 2023.                                           *
//* MODIFICADO.: ABRIL 2026 - Modernización a SQLRPGLE                *
//***********************************************************************

Ctl-Opt DatFmt(*ISO) Copyright('Copyright NovaTalentos 2023') 
        Debug(*Yes) Option(*SrcStmt:*NoDebugIO);

// Archivos de pantalla
Dcl-F MANPROFM WorkStn Sfile(PANTSFLPRO:RRN) InfDs(InfoDS);

// Data Structures
Dcl-Ds InfoDS;
  RRN Int(10) Pos(378);
End-Ds;

// Variables globales
Dcl-S gMsgErr Char(50);
Dcl-S gRecNo Int(10);

//***********************************************************************
//* PROGRAMA PRINCIPAL
//***********************************************************************
DspSfl();

Dow Not *In03;
  Dow Not *In05;
    If *In06;
      AddRecord();
    Else;
      ReadSfl();
    EndIf;
    *In05 = *On;
  EndDo;
  
  ClrSfl();
  FillSfl();
  DspSfl();
EndDo;

*InLR = *On;
Return;

//***********************************************************************
//* PROCEDIMIENTO: Inicialización
//***********************************************************************
Dcl-Proc Initialize;
  *In50 = *Off;
  *In51 = *Off;
  *In52 = *Off;
  *In45 = *Off;
  RRN = 0;
  gRecNo = 1;
  ClrSfl();
  FillSfl();
End-Proc;

//***********************************************************************
//* PROCEDIMIENTO: Limpiar Subfile
//***********************************************************************
Dcl-Proc ClrSfl;
  RRN = 0;
  *In50 = *On;
  Write PANTCNTPRO;
  *In50 = *Off;
End-Proc;

//***********************************************************************
//* PROCEDIMIENTO: Llenar Subfile con SQL
//***********************************************************************
Dcl-Proc FillSfl;
  Dcl-S lCodPro Int(10);
  Dcl-S lNomPro Char(50);
  
  *In45 = *Off;
  
  // Cursor SQL para leer todas las provincias
  Exec SQL
    DECLARE C1 CURSOR FOR
    SELECT IDPROV, NOMPRO
    FROM SISPROV
    ORDER BY IDPROV;
  
  Exec SQL OPEN C1;
  
  Exec SQL FETCH C1 INTO :lCodPro, :lNomPro;
  
  Dow SQLCODE = 0 And RRN < 9999;
    VARCODPRO = lCodPro;
    VARNOMPRO = lNomPro;
    RRN += 1;
    Write PANTSFLPRO;
    
    Exec SQL FETCH C1 INTO :lCodPro, :lNomPro;
  EndDo;
  
  Exec SQL CLOSE C1;
End-Proc;

//***********************************************************************
//* PROCEDIMIENTO: Desplegar Subfile
//***********************************************************************
Dcl-Proc DspSfl;
  *In51 = *On;
  *In52 = *On;
  
  If RRN <= 0;
    *In52 = *Off;
  EndIf;
  
  Write PANTINIPIE;
  ExFmt PANTCNTPRO;
  gMsgErr = *Blanks;
  
  *In51 = *Off;
  *In52 = *Off;
End-Proc;

//***********************************************************************
//* PROCEDIMIENTO: Añadir Registro con SQL
//***********************************************************************
Dcl-Proc AddRecord;
  Dcl-S lError Char(50);
  Dcl-S lCount Int(10);
  
  Dow Not *In12;
    ExFmt PANTINSPRO;
    lError = *Blanks;
    
    // Validaciones
    If CODPROFM = 0;
      lError = 'DIGITE UN CODIGO DE PROVINCIA';
    EndIf;
    
    If NOMPROFM = *Blanks;
      lError = 'DIGITE UNA DESCRIPCIÓN DE PROVINCIA';
    EndIf;
    
    // Verificar si existe con SQL
    If lError = *Blanks;
      Exec SQL
        SELECT COUNT(*)
        INTO :lCount
        FROM SISPROV
        WHERE IDPROV = :CODPROFM;
      
      If lCount > 0;
        lError = 'PROVINCIA YA EXISTE';
      EndIf;
    EndIf;
    
    // Insertar registro con SQL
    If lError = *Blanks And Not *In12;
      Exec SQL
        INSERT INTO SISPROV (IDPROV, NOMPRO)
        VALUES (:CODPROFM, :NOMPROFM);
      
      If SQLCODE = 0;
        Leave;
      Else;
        lError = 'ERROR AL INSERTAR REGISTRO';
      EndIf;
    EndIf;
    
    VERROR = lError;
  EndDo;
  
  *In01 = *Off;
  *In12 = *Off;
End-Proc;

//***********************************************************************
//* PROCEDIMIENTO: Leer Subfile
//***********************************************************************
Dcl-Proc ReadSfl;
  ReadC PANTSFLPRO;
  
  Dow Not %Eof();
    Select;
      When VAROPC = 2;
        // Editar - Por implementar
        EditRecord();
        VAROPC = 0;
        
      When VAROPC = 4;
        // Eliminar - Por implementar
        DeleteRecord();
        VAROPC = 0;
        
      When VAROPC = 5;
        // Consultar
        ConsultRecord();
        VAROPC = 0;
        
      Other;
        gMsgErr = 'OPCIÓN INCORRECTA';
    EndSl;
    
    ReadC PANTSFLPRO;
  EndDo;
End-Proc;

//***********************************************************************
//* PROCEDIMIENTO: Consultar Registro con SQL
//***********************************************************************
Dcl-Proc ConsultRecord;
  Dcl-S lCodPro Int(10);
  Dcl-S lNomPro Char(50);
  
  lCodPro = VARCODPRO;
  
  // Buscar registro con SQL
  Exec SQL
    SELECT IDPROV, NOMPRO
    INTO :lCodPro, :lNomPro
    FROM SISPROV
    WHERE IDPROV = :lCodPro;
  
  If SQLCODE = 0;
    CODPROFM = lCodPro;
    NOMPROFM = lNomPro;
    
    Dow Not *In12;
      ExFmt PANTCONPRO;
    EndDo;
    
    *In12 = *Off;
  Else;
    gMsgErr = 'EL REGISTRO NO EXISTE. REFRESQUE';
  EndIf;
End-Proc;

//***********************************************************************
//* PROCEDIMIENTO: Editar Registro con SQL
//***********************************************************************
Dcl-Proc EditRecord;
  Dcl-S lCodPro Int(10);
  Dcl-S lNomPro Char(50);
  Dcl-S lError Char(50);
  
  lCodPro = VARCODPRO;
  
  // Buscar registro con SQL
  Exec SQL
    SELECT IDPROV, NOMPRO
    INTO :lCodPro, :lNomPro
    FROM SISPROV
    WHERE IDPROV = :lCodPro;
  
  If SQLCODE = 0;
    CODPROFM = lCodPro;
    NOMPROFM = lNomPro;
    
    Dow Not *In12;
      ExFmt PANTINSPRO;
      lError = *Blanks;
      
      // Validaciones
      If NOMPROFM = *Blanks;
        lError = 'DIGITE UNA DESCRIPCIÓN DE PROVINCIA';
      EndIf;
      
      // Actualizar registro con SQL
      If lError = *Blanks And Not *In12;
        Exec SQL
          UPDATE SISPROV
          SET NOMPRO = :NOMPROFM
          WHERE IDPROV = :CODPROFM;
        
        If SQLCODE = 0;
          Leave;
        Else;
          lError = 'ERROR AL ACTUALIZAR REGISTRO';
        EndIf;
      EndIf;
      
      VERROR = lError;
    EndDo;
    
    *In12 = *Off;
  Else;
    gMsgErr = 'EL REGISTRO NO EXISTE. REFRESQUE';
  EndIf;
End-Proc;

//***********************************************************************
//* PROCEDIMIENTO: Eliminar Registro con SQL
//***********************************************************************
Dcl-Proc DeleteRecord;
  Dcl-S lCodPro Int(10);
  Dcl-S lNomPro Char(50);
  Dcl-S lConfirm Char(1);
  
  lCodPro = VARCODPRO;
  
  // Buscar registro con SQL
  Exec SQL
    SELECT IDPROV, NOMPRO
    INTO :lCodPro, :lNomPro
    FROM SISPROV
    WHERE IDPROV = :lCodPro;
  
  If SQLCODE = 0;
    CODPROFM = lCodPro;
    NOMPROFM = lNomPro;
    
    // Mostrar pantalla de confirmación
    Dow Not *In12;
      ExFmt PANTCONPRO;
      
      // Aquí se debería agregar una pantalla de confirmación
      // Por ahora, asumimos que el usuario confirma
      If Not *In12;
        Exec SQL
          DELETE FROM SISPROV
          WHERE IDPROV = :lCodPro;
        
        If SQLCODE = 0;
          gMsgErr = 'REGISTRO ELIMINADO EXITOSAMENTE';
          Leave;
        Else;
          gMsgErr = 'ERROR AL ELIMINAR REGISTRO';
        EndIf;
      EndIf;
    EndDo;
    
    *In12 = *Off;
  Else;
    gMsgErr = 'EL REGISTRO NO EXISTE. REFRESQUE';
  EndIf;
End-Proc;

//***********************************************************************
//* Inicialización automática al inicio del programa
//***********************************************************************
Initialize();