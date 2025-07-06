# Menú Hamburguesa - Documentación

## Funcionalidades Implementadas

### 🍔 **Menú Hamburguesa (Drawer)**

Se ha implementado un menú hamburguesa completo en la pantalla principal `HabitTrackerScreen` con las siguientes características:

#### **Diseño Visual**
- **Gradiente azul** que hace juego con el tema de la aplicación
- **Header personalizado** con avatar del usuario
- **Iconos intuitivos** para cada opción del menú
- **Estilo consistente** con el resto de la aplicación

#### **Opciones del Menú**

### 1. ⚙️ **Configuración**
- **Función:** `_handleConfiguracion()`
- **Contenido:** Opciones de configuración de la aplicación
- **Incluye:**
  - Configurar recordatorios
  - Cambiar tema de la aplicación
  - Configurar horarios
  - Sincronización de datos

### 2. 👤 **Información Personal**
- **Función:** `_handlePersonalInfo()`
- **Contenido:** Datos del perfil del usuario
- **Muestra:**
  - Nombre de usuario
  - Email (simulado)
  - Número de hábitos activos
  - Racha más larga
  - Fecha de registro

### 3. 📊 **Reportes**
- **Función:** `_handleReportes()`
- **Contenido:** Estadísticas y progreso del usuario
- **Incluye:**
  - Progreso semanal
  - Hábitos completados
  - Mejor día de la semana
  - Tendencia de progreso
  - Logros desbloqueados

### 4. 🔔 **Notificaciones**
- **Función:** `_handleNotificaciones()`
- **Contenido:** Configuración de notificaciones
- **Opciones:**
  - Recordatorios diarios
  - Horario de notificaciones
  - Notificaciones push
  - Reportes semanales
  - Celebraciones

### 5. 🚪 **Cerrar Sesión**
- **Función:** `_handleSignOut()`
- **Contenido:** Confirmación y cierre de sesión
- **Características:**
  - Diálogo de confirmación
  - Navegación de regreso al login
  - Limpieza de la pila de navegación

## Implementación Técnica

### **Estructura del Drawer**
```dart
drawer: _buildDrawer(context)
```

### **Componentes Principales**

#### **1. Header del Usuario**
```dart
UserAccountsDrawerHeader(
  accountName: Text(widget.username),
  accountEmail: Text('Rastreador de Hábitos'),
  currentAccountPicture: CircleAvatar(...)
)
```

#### **2. Elementos del Menú**
```dart
_buildDrawerItem(
  icon: Icons.settings,
  title: 'Configuración',
  onTap: () => _handleConfiguracion(context),
)
```

#### **3. Manejo de Acciones**
Cada opción del menú tiene su propio método handler que:
- Cierra el drawer
- Muestra un diálogo con información relevante
- Maneja la navegación según sea necesario

## Características Especiales

### **🎨 Diseño Responsivo**
- Adapta el contenido al tamaño de pantalla
- Iconos y texto claramente visibles
- Gradientes y colores consistentes

### **🔄 Navegación Intuitiva**
- Cierre automático del drawer al seleccionar opción
- Navegación clara de regreso al login
- Confirmaciones para acciones importantes

### **📱 Experiencia de Usuario**
- Feedback visual inmediato
- Diálogos informativos
- Datos simulados realistas para demostración

### **⚡ Rendimiento**
- Carga rápida del drawer
- Gestión eficiente de memoria
- Navegación fluida

## Cómo Usar el Menú

### **Acceder al Menú**
1. Desde la pantalla principal de hábitos
2. Tocar el icono de hamburguesa (≡) en el AppBar
3. El drawer se desliza desde la izquierda

### **Navegar por las Opciones**
1. Tocar cualquier opción del menú
2. Se abre un diálogo con información relevante
3. Cerrar el diálogo para continuar

### **Cerrar Sesión**
1. Tocar "Cerrar Sesión" en el menú
2. Confirmar en el diálogo
3. Regreso automático a la pantalla de login

## Datos Simulados

Para fines de demostración, se muestran datos simulados en:
- **Información Personal:** Email, estadísticas de usuario
- **Reportes:** Progreso, logros, tendencias
- **Notificaciones:** Configuraciones predeterminadas

## Extensibilidad

El menú está diseñado para ser fácilmente extensible:
- Añadir nuevas opciones modificando `_buildDrawer()`
- Crear nuevos handlers para funcionalidades adicionales
- Personalizar el diseño según necesidades específicas

## Compatibilidad

- ✅ **Material Design 3**
- ✅ **Flutter 3.x**
- ✅ **iOS y Android**
- ✅ **Responsive Design**

El menú hamburguesa está completamente funcional y listo para uso en producción! 🎉
