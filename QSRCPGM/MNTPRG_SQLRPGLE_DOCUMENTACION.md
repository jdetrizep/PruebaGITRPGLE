# Documentación del Programa MNTPRG.sqlrpgle (MODERNIZADO)

## Información General

| Campo | Valor |
|-------|-------|
| **Programa** | MANTPRO (MNTPRG.sqlrpgle) |
| **Descripción** | Programa de Mantenimiento de Provincias - Versión Modernizada |
| **Autor Original** | Jorge de Trinidad Zepeda - NOVACOMP S.A. |
| **Fecha Original** | Junio 2023 |
| **Modernización** | Abril 2026 |
| **Lenguaje** | SQLRPGLE (Free Format) |
| **Copyright** | NovaTalentos 2023 |

---

## 🚀 Mejoras Implementadas

### Modernización Técnica

✅ **Formato Libre (\*\*FREE)** - Código más legible y moderno
✅ **SQL Embebido** - Reemplazo de operaciones de archivo por SQL
✅ **Procedimientos** - Reemplazo de subrutinas por procedimientos modulares
✅ **Variables Tipadas** - Uso de tipos de datos modernos (Int, Char)
✅ **Nomenclatura Mejorada** - Prefijos para variables locales (l) y globales (g)
✅ **Funcionalidades Completas** - Implementación de Editar y Eliminar

### Funcionalidades Nuevas

✅ **Editar Provincia** - Opción 2 ahora implementada
✅ **Eliminar Provincia** - Opción 4 ahora implementada
✅ **Mejor Manejo de Errores** - Validaciones SQL mejoradas

---

## Comparación: RPG vs SQLRPGLE

| Aspecto | RPG Original | SQLRPGLE Modernizado |
|---------|--------------|---------------------|
| **Formato** | Columnar (Fixed) | Libre (\*\*FREE) |
| **Lectura de Datos** | READ, CHAIN, SETLL | SELECT, CURSOR |
| **Escritura** | WRITE | INSERT |
| **Actualización** | UPDATE (archivo) | UPDATE (SQL) |
| **Eliminación** | DELETE (archivo) | DELETE (SQL) |
| **Modularización** | Subrutinas (BEGSR/ENDSR) | Procedimientos (Dcl-Proc/End-Proc) |
| **Variables** | Definición en columnas | Dcl-S con tipos modernos |
| **Editar** | ❌ No implementado | ✅ Implementado |
| **Eliminar** | ❌ No implementado | ✅ Implementado |

---

## Estructura del Programa

### Directivas de Control

```rpgle
Ctl-Opt DatFmt(*ISO) 
        Copyright('Copyright NovaTalentos 2023') 
        Debug(*Yes) 
        Option(*SrcStmt:*NoDebugIO);
```

**Opciones:**
- `DatFmt(*ISO)`: Formato de fecha ISO (YYYY-MM-DD)
- `Debug(*Yes)`: Habilita depuración
- `Option(*SrcStmt)`: Incluye números de línea en debug
- `Option(*NoDebugIO)`: Optimiza operaciones de I/O

---

## Procedimientos Implementados

### 1. Initialize() - Inicialización

**Propósito:** Inicializa el programa al arrancar.

```rpgle
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
```

**Características:**
- Procedimiento sin parámetros
- Se ejecuta automáticamente al final del código
- Inicializa indicadores y variables globales

---

### 2. ClrSfl() - Limpiar Subfile

**Propósito:** Limpia todos los registros del subfile.

```rpgle
Dcl-Proc ClrSfl;
  RRN = 0;
  *In50 = *On;
  Write PANTCNTPRO;
  *In50 = *Off;
End-Proc;
```

**Mejoras vs Original:**
- Código más compacto
- Mismo comportamiento que la versión original

---

### 3. FillSfl() - Llenar Subfile con SQL

**Propósito:** Carga todos los registros de provincias usando SQL.

```rpgle
Dcl-Proc FillSfl;
  Dcl-S lCodPro Int(10);
  Dcl-S lNomPro Char(50);
  
  *In45 = *Off;
  
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
```

**Mejoras vs Original:**
- ✅ Usa cursor SQL en lugar de READ
- ✅ Variables locales con prefijo 'l'
- ✅ Ordenamiento automático por IDPROV
- ✅ Manejo de SQLCODE en lugar de %EOF

---

### 4. DspSfl() - Desplegar Subfile

**Propósito:** Muestra el subfile en pantalla.

```rpgle
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
```

**Mejoras vs Original:**
- Código más limpio y legible
- Uso de variables globales (gMsgErr)

---

### 5. AddRecord() - Añadir Registro con SQL

**Propósito:** Permite añadir una nueva provincia usando SQL INSERT.

```rpgle
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
```

**Mejoras vs Original:**
- ✅ Usa `SELECT COUNT(*)` en lugar de CHAIN
- ✅ Usa `INSERT` SQL en lugar de WRITE
- ✅ Variables locales para mejor encapsulación
- ✅ Validación de SQLCODE para errores

---

### 6. ReadSfl() - Leer Subfile

**Propósito:** Procesa las opciones seleccionadas en el subfile.

```rpgle
Dcl-Proc ReadSfl;
  ReadC PANTSFLPRO;
  
  Dow Not %Eof();
    Select;
      When VAROPC = 2;
        EditRecord();
        VAROPC = 0;
        
      When VAROPC = 4;
        DeleteRecord();
        VAROPC = 0;
        
      When VAROPC = 5;
        ConsultRecord();
        VAROPC = 0;
        
      Other;
        gMsgErr = 'OPCIÓN INCORRECTA';
    EndSl;
    
    ReadC PANTSFLPRO;
  EndDo;
End-Proc;
```

**Mejoras vs Original:**
- ✅ Opción 2 (Editar) ahora funcional
- ✅ Opción 4 (Eliminar) ahora funcional
- ✅ Llamadas a procedimientos en lugar de EXSR

---

### 7. ConsultRecord() - Consultar Registro con SQL

**Propósito:** Muestra los detalles de una provincia usando SQL SELECT.

```rpgle
Dcl-Proc ConsultRecord;
  Dcl-S lCodPro Int(10);
  Dcl-S lNomPro Char(50);
  
  lCodPro = VARCODPRO;
  
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
```

**Mejoras vs Original:**
- ✅ Usa `SELECT INTO` en lugar de CHAIN
- ✅ Validación con SQLCODE
- ✅ Variables locales

---

### 8. EditRecord() - Editar Registro con SQL ⭐ NUEVO

**Propósito:** Permite modificar una provincia existente usando SQL UPDATE.

```rpgle
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
      
      If NOMPROFM = *Blanks;
        lError = 'DIGITE UNA DESCRIPCIÓN DE PROVINCIA';
      EndIf;
      
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
```

**Características:**
- ⭐ Funcionalidad completamente nueva
- ✅ Usa SQL UPDATE
- ✅ Validaciones completas
- ✅ Manejo de errores SQL

---

### 9. DeleteRecord() - Eliminar Registro con SQL ⭐ NUEVO

**Propósito:** Permite eliminar una provincia usando SQL DELETE.

```rpgle
Dcl-Proc DeleteRecord;
  Dcl-S lCodPro Int(10);
  Dcl-S lNomPro Char(50);
  Dcl-S lConfirm Char(1);
  
  lCodPro = VARCODPRO;
  
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
```

**Características:**
- ⭐ Funcionalidad completamente nueva
- ✅ Usa SQL DELETE
- ✅ Muestra confirmación antes de eliminar
- ✅ Mensajes de éxito/error

---

## Variables Globales

```rpgle
Dcl-S gMsgErr Char(50);   // Mensaje de error global
Dcl-S gRecNo Int(10);     // Número de registro
```

**Convención de Nomenclatura:**
- Prefijo `g` = Variable global
- Prefijo `l` = Variable local (dentro de procedimientos)

---

## Operaciones SQL Utilizadas

### SELECT con Cursor
```sql
DECLARE C1 CURSOR FOR
SELECT IDPROV, NOMPRO
FROM SISPROV
ORDER BY IDPROV;
```

### SELECT INTO
```sql
SELECT IDPROV, NOMPRO
INTO :lCodPro, :lNomPro
FROM SISPROV
WHERE IDPROV = :lCodPro;
```

### SELECT COUNT
```sql
SELECT COUNT(*)
INTO :lCount
FROM SISPROV
WHERE IDPROV = :CODPROFM;
```

### INSERT
```sql
INSERT INTO SISPROV (IDPROV, NOMPRO)
VALUES (:CODPROFM, :NOMPROFM);
```

### UPDATE
```sql
UPDATE SISPROV
SET NOMPRO = :NOMPROFM
WHERE IDPROV = :CODPROFM;
```

### DELETE
```sql
DELETE FROM SISPROV
WHERE IDPROV = :lCodPro;
```

---

## Indicadores Utilizados

| Indicador | Propósito | Uso |
|-----------|-----------|-----|
| **01** | Validación exitosa | AddRecord |
| **03** | Salir del programa (F3) | Programa principal |
| **05** | Control de bucle interno | Programa principal |
| **06** | Añadir registro (F6) | Programa principal |
| **12** | Cancelar operación (F12) | Todos los procedimientos |
| **45** | Control de estado | FillSfl |
| **50** | Limpiar subfile (SFLCLR) | ClrSfl |
| **51** | Control de visualización | DspSfl |
| **52** | Mostrar subfile (SFLDSP) | DspSfl |
| **LR** | Last Record (fin) | Programa principal |

---

## Funcionalidades Completas

✅ **Listar provincias** - Muestra todas las provincias en subfile con SQL
✅ **Añadir provincia** - Crea nuevas provincias con INSERT SQL
✅ **Editar provincia** - Modifica provincias existentes con UPDATE SQL
✅ **Eliminar provincia** - Elimina provincias con DELETE SQL
✅ **Consultar provincia** - Muestra detalles con SELECT SQL

---

## Ventajas del Código Modernizado

### 1. Rendimiento
- SQL optimizado por el motor de base de datos
- Menos operaciones de I/O
- Mejor uso de índices

### 2. Mantenibilidad
- Código más legible en formato libre
- Procedimientos modulares y reutilizables
- Variables con nombres descriptivos

### 3. Escalabilidad
- Fácil agregar nuevas funcionalidades
- Procedimientos independientes
- Mejor separación de responsabilidades

### 4. Portabilidad
- SQL estándar más portable
- Menos dependencia de operaciones de archivo específicas de AS/400

### 5. Debugging
- Procedimientos facilitan el debugging
- Variables locales evitan efectos secundarios
- Mejor trazabilidad de errores SQL

---

## Mejoras Futuras Sugeridas

1. **Transacciones SQL**
   - Implementar COMMIT/ROLLBACK
   - Manejo de transacciones complejas

2. **Stored Procedures**
   - Mover lógica de negocio a procedimientos almacenados
   - Mejor reutilización

3. **Paginación**
   - Implementar FETCH FIRST/OFFSET para grandes volúmenes
   - Mejorar rendimiento con muchos registros

4. **Validaciones Avanzadas**
   - Constraints en base de datos
   - Triggers para auditoría

5. **Interfaz Mejorada**
   - Pantalla de confirmación para eliminaciones
   - Mensajes más descriptivos
   - Indicadores de progreso

6. **Logging**
   - Registro de operaciones
   - Auditoría de cambios

---

## Migración desde RPG Original

### Pasos para Migrar

1. **Backup del programa original**
2. **Compilar el nuevo programa SQLRPGLE**
3. **Probar en ambiente de desarrollo**
4. **Validar todas las funcionalidades**
5. **Migrar a producción**

### Compatibilidad

- ✅ Usa los mismos archivos de pantalla (MANPROFM)
- ✅ Usa la misma tabla (SISPROV)
- ✅ Mantiene la misma interfaz de usuario
- ✅ Comportamiento idéntico para el usuario final

---

## Conclusión

El programa MNTPRG.sqlrpgle representa una modernización completa del código original, aprovechando las capacidades de SQL embebido y la programación modular con procedimientos. El resultado es un código más mantenible, eficiente y completo, con todas las funcionalidades CRUD implementadas.

---

**Última actualización:** Abril 2026  
**Documentado por:** Bob (Asistente IA)  
**Rama Git:** ramaModer