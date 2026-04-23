# Documentación del Programa MNTPRG.rpg

## Información General

| Campo | Valor |
|-------|-------|
| **Programa** | MANTPRO (MNTPRG.rpg) |
| **Descripción** | Programa de Mantenimiento de Provincias |
| **Autor** | Jorge de Trinidad Zepeda - NOVACOMP S.A. |
| **Fecha** | Junio 2023 |
| **Copyright** | NovaTalentos 2023 |

---

## Propósito

Este programa permite realizar operaciones de mantenimiento (ABM - Alta, Baja, Modificación) sobre el archivo de provincias `SISPROV`. Utiliza una interfaz de subfile para mostrar y gestionar los registros de provincias.

---

## Archivos Utilizados

### Archivos de Pantalla
- **MANPROFM** (WORKSTN) - Archivo de pantalla con subfile
  - Formato de subfile: `PANTSFLPRO`
  - Variable de control RRN (Relative Record Number)

### Archivos de Base de Datos
- **SISPROV** (DISK) - Archivo físico de provincias
  - Modo: Update (UF)
  - Acceso: Keyed (K)
  - Campos principales:
    - `IDPROV` - ID de provincia (9,0)
    - `NOMPRO` - Nombre de provincia

---

## Estructura del Programa

### Data Structures (DS)

```rpg
DINFDS            DS
DRRN                             4  0
```

- **INFDS**: Information Data Structure para el archivo de pantalla
- **RRN**: Relative Record Number para control del subfile

---

## Flujo Principal del Programa

```
INICIO
  ↓
DSPSFL (Desplegar Subfile)
  ↓
BUCLE PRINCIPAL (*IN03 = OFF)
  ↓
  ├─→ Si *IN06 (F6) → SRADD (Añadir)
  │
  └─→ Si NO → LEESFL (Leer Subfile)
  ↓
CLRSFL (Limpiar Subfile)
  ↓
FILSFL (Llenar Subfile)
  ↓
DSPSFL (Desplegar Subfile)
  ↓
FIN (*INLR = ON)
```

---

## Subrutinas Detalladas

### 1. *INZSR - Inicialización (Líneas 41-48)

**Propósito:** Inicializa el programa al arrancar.

**Acciones:**
- Desactiva indicadores 50, 51, 52, 45
- Inicializa RRN a cero
- Establece S_RECNO = 1
- Limpia el subfile (CLRSFL)
- Llena el subfile (FILSFL)

---

### 2. CLRSFL - Limpiar Subfile (Líneas 51-56)

**Propósito:** Limpia todos los registros del subfile.

**Proceso:**
1. Establece RRN = 0
2. Activa indicador 50 (SFLCLR)
3. Escribe registro de control PANTCNTPRO
4. Desactiva indicador 50

**Indicadores:**
- **50**: Control de limpieza del subfile (SFLCLR)

---

### 3. FILSFL - Llenar Subfile (Líneas 59-74)

**Propósito:** Carga todos los registros de provincias en el subfile.

**Proceso:**
1. Desactiva indicador 45
2. Posiciona al inicio del archivo SISPROV (*LOVAL SETLL)
3. Lee todos los registros hasta EOF
4. Por cada registro:
   - Copia IDPROV → VARCODPRO
   - Copia NOMPRO → VARNOMPRO
   - Incrementa RRN
   - Escribe registro en subfile PANTSFLPRO
5. Límite máximo: 9999 registros

**Variables:**
- `VARCODPRO`: Código de provincia para el subfile
- `VARNOMPRO`: Nombre de provincia para el subfile

---

### 4. DSPSFL - Desplegar Subfile (Líneas 77-86)

**Propósito:** Muestra el subfile en pantalla y espera interacción del usuario.

**Proceso:**
1. Activa indicadores 51 y 52 (control de visualización)
2. Si RRN <= 0, desactiva indicador 52 (subfile vacío)
3. Escribe pie de pantalla (PANTINIPIE)
4. Muestra pantalla de control (EXFMT PANTCNTPRO)
5. Limpia mensaje de error
6. Desactiva indicadores 51 y 52

**Indicadores:**
- **51**: Control de visualización
- **52**: SFLDSP (Display Subfile)

---

### 5. SRADD - Añadir Registro (Líneas 89-113)

**Propósito:** Permite añadir una nueva provincia.

**Validaciones:**
1. Código de provincia no puede ser cero
2. Nombre de provincia no puede estar en blanco
3. La provincia no debe existir previamente

**Proceso:**
1. Muestra pantalla de inserción (EXFMT PANTINSPRO)
2. Valida datos ingresados
3. Verifica si la provincia ya existe (CHAIN)
4. Si todo es válido (*IN01):
   - Copia datos a campos del archivo
   - Escribe registro (WRITE SISRPROV)
   - Limpia buffer del registro
   - Sale del bucle

**Mensajes de Error:**
- "DIGITE UN CODIGO DE PROVINCIA"
- "DIGITE UNA DESCRICIÓN DE PROVINCIA"
- "PROVINCIA YA EXISTEÜÜÜÜ"

**Indicadores:**
- **12**: Cancelar operación (F12)
- **01**: Validación exitosa

---

### 6. LEESFL - Leer Subfile (Líneas 116-132)

**Propósito:** Procesa las opciones seleccionadas en el subfile.

**Opciones Disponibles:**
- **2**: Editar (no implementado)
- **4**: Eliminar (no implementado)
- **5**: Consultar → Llama a SRCONS

**Proceso:**
1. Lee registros modificados del subfile (READC)
2. Evalúa la opción seleccionada (VAROPC)
3. Ejecuta la acción correspondiente
4. Limpia la opción (VAROPC = 0)
5. Continúa con el siguiente registro modificado

**Mensaje de Error:**
- "OPCIÓN INCORRECTAÜÜÜ" - Si la opción no es válida

---

### 7. SRCONS - Consultar Registro (Líneas 135-148)

**Propósito:** Muestra los detalles de una provincia seleccionada.

**Proceso:**
1. Obtiene el código de provincia del subfile (VARCODPRO)
2. Busca el registro en SISPROV (CHAIN)
3. Si se encuentra:
   - Carga datos en pantalla de consulta
   - Muestra pantalla (EXFMT PANTCONPRO)
   - Espera hasta que el usuario presione F12
4. Si no se encuentra:
   - Muestra mensaje "EL REGISTRO NO EXISTE. REFRESQUEÜÜ"

**Indicadores:**
- **12**: Salir de la consulta (F12)

---

## Indicadores Utilizados

| Indicador | Propósito | Ubicación |
|-----------|-----------|-----------|
| **01** | Validación exitosa en SRADD | Línea 104 |
| **03** | Salir del programa (F3) | Línea 26 |
| **05** | Control de bucle interno | Líneas 27, 33 |
| **06** | Añadir registro (F6) | Línea 28 |
| **12** | Cancelar operación (F12) | Líneas 90, 112, 141, 144 |
| **45** | Control de estado (desactivado) | Líneas 43, 60 |
| **50** | Limpiar subfile (SFLCLR) | Líneas 53, 55 |
| **51** | Control de visualización | Líneas 78, 85 |
| **52** | Mostrar subfile (SFLDSP) | Líneas 78, 80, 85 |
| **LR** | Last Record (fin de programa) | Línea 39 |

---

## Campos de Pantalla

### Pantalla de Subfile
- `VAROPC`: Opción seleccionada (2=Editar, 4=Eliminar, 5=Consultar)
- `VARCODPRO`: Código de provincia (display)
- `VARNOMPRO`: Nombre de provincia (display)

### Pantalla de Inserción/Consulta
- `CODPROFM`: Código de provincia (input)
- `NOMPROFM`: Nombre de provincia (input)

### Mensajes
- `MSGERR`: Mensaje de error
- `VERROR`: Variable de error en validaciones

---

## Funcionalidades Implementadas

✅ **Listar provincias** - Muestra todas las provincias en subfile
✅ **Añadir provincia** - Permite crear nuevas provincias con validaciones
✅ **Consultar provincia** - Muestra detalles de una provincia seleccionada

## Funcionalidades Pendientes

❌ **Editar provincia** - Opción 2 no implementada
❌ **Eliminar provincia** - Opción 4 no implementada

---

## Teclas de Función

| Tecla | Función | Indicador |
|-------|---------|-----------|
| **F3** | Salir del programa | *IN03 |
| **F6** | Añadir nueva provincia | *IN06 |
| **F12** | Cancelar operación actual | *IN12 |

---

## Limitaciones

1. **Máximo de registros en subfile**: 9999 registros
2. **Funciones no implementadas**: Editar (opción 2) y Eliminar (opción 4)
3. **Caracteres especiales**: El código usa "Ü" como separador en mensajes de error

---

## Notas Técnicas

- El programa usa formato libre de RPG IV (columnas libres)
- Formato de fecha: *ISO (YYYY-MM-DD)
- Modo DEBUG activado (*YES)
- El subfile se recarga completamente después de cada operación
- No hay paginación implementada para el subfile

---

## Mejoras Sugeridas

1. Implementar las funciones de Editar y Eliminar
2. Agregar paginación para manejar más de 9999 registros
3. Implementar búsqueda/filtrado de provincias
4. Agregar confirmación antes de operaciones críticas
5. Mejorar manejo de errores con mensajes más descriptivos
6. Implementar actualización parcial del subfile en lugar de recarga completa

---

**Última actualización:** Abril 2026
**Documentado por:** Bob (Asistente IA)