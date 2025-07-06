import 'package:flutter/material.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';

class HabitTrackerScreen extends StatefulWidget {
  final String username;
  const HabitTrackerScreen({super.key, required this.username});

  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};

  @override
  void initState() {
    super.initState();
    // Cargar algunos hábitos de ejemplo para demostración
    _loadSampleHabits();
  }

  void _loadSampleHabits() {
    setState(() {
      selectedHabitsMap = {
        'Ejercicio Matutino': 'FF5722', // Deep Orange
        'Beber Agua': '2196F3', // Blue
        'Leer 30 minutos': '4CAF50', // Green
      };
      completedHabitsMap = {
        'Meditar': '9C27B0', // Purple
      };
    });
  }

  Future<void> _saveHabits() async {
    //guardar hábitos en preferencias en el futuro
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Agregar opacidad si no está incluida.
    }
    return Color(int.parse('0x$hexColor'));
  }

  Color _getHabitColor(String habit, Map<String, String> habitsMap) {
    String? colorHex = habitsMap[habit];
    if (colorHex != null) {
      try {
        return _getColorFromHex(colorHex);
      } catch (e) {
        print('Error al analizar el color para $habit: $e');
      }
    }
    return Colors.blue; // Color predeterminado en caso de error.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          widget.username.isNotEmpty ? '${widget.username} - Hábitos' : 'Rastreador de Hábitos',
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
      ),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Por Hacer 📝',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          selectedHabitsMap.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text(
                      '¡Usa el botón + para crear algunos hábitos!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: selectedHabitsMap.length,
                    itemBuilder: (context, index) {
                      String habit = selectedHabitsMap.keys.elementAt(index);
                      Color habitColor =
                          _getHabitColor(habit, selectedHabitsMap);
                      return Dismissible(
                        key: Key(habit),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            String color = selectedHabitsMap.remove(habit)!;
                            completedHabitsMap[habit] = color;
                            _saveHabits();
                          });
                        },
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Desliza para Completar',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.check, color: Colors.white),
                            ],
                          ),
                        ),
                        child: _buildHabitCard(habit, habitColor),
                      );
                    },
                  ),
                ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Hecho ✅🎉',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          completedHabitsMap.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Desliza hacia la derecha en una actividad para marcarla como hecha.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: completedHabitsMap.length,
                    itemBuilder: (context, index) {
                      String habit = completedHabitsMap.keys.elementAt(index);
                      Color habitColor =
                          _getHabitColor(habit, completedHabitsMap);
                      return Dismissible(
                        key: Key(habit),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          setState(() {
                            String color = completedHabitsMap.remove(habit)!;
                            selectedHabitsMap[habit] = color;
                            _saveHabits();
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            children: [
                              Icon(Icons.undo, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Desliza para Deshacer',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        child: _buildHabitCard(habit, habitColor,
                            isCompleted: true),
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHabitScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue.shade700,
        tooltip: 'Agregar Hábitos',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHabitCard(String title, Color color,
      {bool isCompleted = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      elevation: 4,
      child: SizedBox(
        height: 70, // Ajustar la altura para tarjetas más gruesas.
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          trailing: isCompleted
              ? Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 28,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
          // Añadir navegación al tocar el hábito
          onTap: () {
            _navigateToHabitDetail(title, color, isCompleted);
          },
        ),
      ),
    );
  }

  /// Navega a la pantalla de detalles del hábito
  void _navigateToHabitDetail(String title, Color color, bool isCompleted) {
    // Crear el objeto del hábito con información detallada
    final habitData = {
      'title': title,
      'description': _getHabitDescription(title),
      'color': color.value.toRadixString(16).padLeft(8, '0').substring(2),
      'isCompleted': isCompleted,
      'streak': _getHabitStreak(title),
      'category': _getHabitCategory(title),
      'difficulty': _getHabitDifficulty(title),
    };

    // Navegar a la pantalla de detalles
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetailScreen(habit: habitData),
      ),
    );
  }

  /// Obtiene la descripción del hábito basada en su título
  String _getHabitDescription(String title) {
    switch (title.toLowerCase()) {
      case 'ejercicio matutino':
        return 'Realiza 30 minutos de ejercicio cada mañana para mantener tu cuerpo activo y saludable.';
      case 'beber agua':
        return 'Mantén tu cuerpo hidratado bebiendo al menos 8 vasos de agua al día.';
      case 'leer 30 minutos':
        return 'Dedica 30 minutos diarios a la lectura para expandir tu conocimiento y relajarte.';
      case 'meditar':
        return 'Practica la meditación durante 10-15 minutos para reducir el estrés y mejorar tu concentración.';
      default:
        return 'Un hábito saludable que contribuye a tu bienestar general.';
    }
  }

  /// Obtiene la racha actual del hábito (simulado)
  int _getHabitStreak(String title) {
    // Simulación de rachas diferentes para cada hábito
    switch (title.toLowerCase()) {
      case 'ejercicio matutino':
        return 7;
      case 'beber agua':
        return 12;
      case 'leer 30 minutos':
        return 5;
      case 'meditar':
        return 3;
      default:
        return 1;
    }
  }

  /// Obtiene la categoría del hábito
  String _getHabitCategory(String title) {
    switch (title.toLowerCase()) {
      case 'ejercicio matutino':
        return 'Salud Física';
      case 'beber agua':
        return 'Salud';
      case 'leer 30 minutos':
        return 'Educación';
      case 'meditar':
        return 'Bienestar Mental';
      default:
        return 'General';
    }
  }

  /// Obtiene la dificultad del hábito
  String _getHabitDifficulty(String title) {
    switch (title.toLowerCase()) {
      case 'ejercicio matutino':
        return 'Medio';
      case 'beber agua':
        return 'Fácil';
      case 'leer 30 minutos':
        return 'Fácil';
      case 'meditar':
        return 'Medio';
      default:
        return 'Medio';
    }
  }

  /// Construye el drawer (menú hamburguesa) con las opciones principales
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade900,
            ],
          ),
        ),
        child: Column(
          children: [
            // Header del drawer con información del usuario
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              accountName: Text(
                widget.username.isNotEmpty ? widget.username : 'Usuario',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: const Text(
                'Rastreador de Hábitos',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.username.isNotEmpty ? widget.username[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ),
            
            // Opciones del menú
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.settings,
                    title: 'Configuración',
                    onTap: () => _handleConfiguracion(context),
                  ),
                  _buildDrawerItem(
                    icon: Icons.person,
                    title: 'Información Personal',
                    onTap: () => _handlePersonalInfo(context),
                  ),
                  _buildDrawerItem(
                    icon: Icons.bar_chart,
                    title: 'Reportes',
                    onTap: () => _handleReportes(context),
                  ),
                  _buildDrawerItem(
                    icon: Icons.notifications,
                    title: 'Notificaciones',
                    onTap: () => _handleNotificaciones(context),
                  ),
                  const Divider(color: Colors.white24),
                  _buildDrawerItem(
                    icon: Icons.logout,
                    title: 'Cerrar Sesión',
                    onTap: () => _handleSignOut(context),
                    isSignOut: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye un elemento del drawer con estilo consistente
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSignOut = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSignOut ? Colors.red.shade300 : Colors.white,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSignOut ? Colors.red.shade300 : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  /// Maneja la opción de Configuración
  void _handleConfiguracion(BuildContext context) {
    Navigator.pop(context); // Cerrar drawer
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.settings, color: Colors.blue),
              SizedBox(width: 8),
              Text('Configuración'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Configurar recordatorios'),
              SizedBox(height: 8),
              Text('• Cambiar tema de la aplicación'),
              SizedBox(height: 8),
              Text('• Configurar horarios'),
              SizedBox(height: 8),
              Text('• Sincronización de datos'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  /// Maneja la opción de Información Personal
  void _handlePersonalInfo(BuildContext context) {
    Navigator.pop(context); // Cerrar drawer
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.person, color: Colors.blue),
              SizedBox(width: 8),
              Text('Información Personal'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('👤 Usuario: ${widget.username}'),
              const SizedBox(height: 12),
              const Text('📧 Email: usuario@ejemplo.com'),
              const SizedBox(height: 12),
              const Text('🎯 Hábitos activos: 4'),
              const SizedBox(height: 12),
              const Text('🔥 Racha más larga: 12 días'),
              const SizedBox(height: 12),
              const Text('📅 Miembro desde: Enero 2025'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  /// Maneja la opción de Reportes
  void _handleReportes(BuildContext context) {
    Navigator.pop(context); // Cerrar drawer
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.bar_chart, color: Colors.blue),
              SizedBox(width: 8),
              Text('Reportes'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📊 Progreso semanal: 85%'),
              SizedBox(height: 12),
              Text('🎯 Hábitos completados: 28/32'),
              SizedBox(height: 12),
              Text('⭐ Mejor día: Lunes'),
              SizedBox(height: 12),
              Text('📈 Tendencia: Mejorando'),
              SizedBox(height: 12),
              Text('🏆 Logros desbloqueados: 5'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  /// Maneja la opción de Notificaciones
  void _handleNotificaciones(BuildContext context) {
    Navigator.pop(context); // Cerrar drawer
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.notifications, color: Colors.blue),
              SizedBox(width: 8),
              Text('Notificaciones'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🔔 Recordatorios diarios: Activado'),
              SizedBox(height: 12),
              Text('⏰ Horario: 08:00 AM'),
              SizedBox(height: 12),
              Text('📱 Notificaciones push: Activado'),
              SizedBox(height: 12),
              Text('📧 Reportes semanales: Activado'),
              SizedBox(height: 12),
              Text('🎉 Celebraciones: Activado'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  /// Maneja la opción de Cerrar Sesión
  void _handleSignOut(BuildContext context) {
    Navigator.pop(context); // Cerrar drawer
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Cerrar Sesión'),
            ],
          ),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login-screen',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }
}
