import 'package:flutter/material.dart';
import 'habit_tracker_screen.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // Datos de ejemplo para las tarjetas de contenido
  List<Map<String, dynamic>> popularMeditations = [
    {
      'title': 'Respiración Consciente',
      'subtitle': 'Calma y Relajación',
      'duration': '10 min',
      'image': 'assets/meditation1.jpg',
      'completed': false,
      'color': Colors.blue,
      'category': 'Principiante',
    },
    {
      'title': 'Meditación Matutina',
      'subtitle': 'Energía y Vitalidad',
      'duration': '15 min',
      'image': 'assets/meditation2.jpg',
      'completed': false,
      'color': Colors.orange,
      'category': 'Intermedio',
    },
    {
      'title': 'Relajación Nocturna',
      'subtitle': 'Sueño Reparador',
      'duration': '20 min',
      'image': 'assets/meditation3.jpg',
      'completed': true,
      'color': Colors.purple,
      'category': 'Avanzado',
    },
    {
      'title': 'Mindfulness',
      'subtitle': 'Atención Plena',
      'duration': '12 min',
      'image': 'assets/meditation4.jpg',
      'completed': false,
      'color': Colors.green,
      'category': 'Principiante',
    },
  ];

  List<Map<String, dynamic>> dailyHabits = [
    {
      'title': 'Beber Agua',
      'subtitle': 'Salud e Hidratación',
      'duration': 'Todo el día',
      'icon': Icons.local_drink,
      'completed': false,
      'progress': 0.6,
      'goal': '8 vasos',
    },
    {
      'title': 'Hacer Ejercicio',
      'subtitle': 'Fitness y Bienestar',
      'duration': '30 min',
      'icon': Icons.fitness_center,
      'completed': true,
      'progress': 1.0,
      'goal': '30 min',
    },
    {
      'title': 'Leer un Libro',
      'subtitle': 'Educación y Cultura',
      'duration': '20 min',
      'icon': Icons.book,
      'completed': false,
      'progress': 0.3,
      'goal': '20 páginas',
    },
    {
      'title': 'Meditar',
      'subtitle': 'Paz Mental',
      'duration': '10 min',
      'icon': Icons.self_improvement,
      'completed': false,
      'progress': 0.0,
      'goal': '10 min',
    },
  ];

  List<Map<String, dynamic>> todayTasks = [
    {
      'title': 'Completar proyecto Flutter',
      'subtitle': 'Trabajo',
      'time': '09:00',
      'priority': 'Alta',
      'completed': false,
    },
    {
      'title': 'Llamar al médico',
      'subtitle': 'Personal',
      'time': '14:30',
      'priority': 'Media',
      'completed': false,
    },
    {
      'title': 'Comprar víveres',
      'subtitle': 'Hogar',
      'time': '18:00',
      'priority': 'Baja',
      'completed': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer/Menu Hamburguesa
      drawer: _buildDrawer(),
      // Barra de Navegación Superior
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.psychology,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'MindFlow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
            ),
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Text(
                widget.username.isNotEmpty ? widget.username[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onPressed: () => _showProfile(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white, Colors.grey.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de Bienvenida con Estadísticas
              _buildWelcomeSection(),
              const SizedBox(height: 24),

              // Sección de Navegación Rápida
              _buildQuickActions(),
              const SizedBox(height: 24),

              // Sección "Meditaciones Populares"
              _buildSectionTitle('Meditaciones Populares', Icons.self_improvement),
              const SizedBox(height: 12),
              _buildMeditationCards(),
              const SizedBox(height: 24),

              // Sección "Progreso de Hábitos"
              _buildSectionTitle('Progreso de Hábitos', Icons.trending_up),
              const SizedBox(height: 12),
              _buildHabitProgress(),
              const SizedBox(height: 24),

              // Sección "Tareas de Hoy"
              _buildSectionTitle('Tareas de Hoy', Icons.today),
              const SizedBox(height: 12),
              _buildTodayTasks(),
              const SizedBox(height: 24),

              // Sección de Motivación
              _buildMotivationCard(),
              const SizedBox(height: 80), // Espacio extra para el FAB
            ],
          ),
        ),
      ),
      // Botón de Acción Flotante
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateOptions(context),
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Crear', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Drawer/Menu Hamburguesa
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header del Drawer
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        widget.username.isNotEmpty ? widget.username[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Hola, ${widget.username}!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bienvenido a MindFlow',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Opciones del Menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  Icons.home,
                  'Inicio',
                  Colors.blue.shade700,
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  Icons.track_changes,
                  'Seguimiento de Hábitos',
                  Colors.green.shade700,
                  () {
                    Navigator.pop(context);
                    _navigateToHabits();
                  },
                ),
                _buildDrawerItem(
                  Icons.self_improvement,
                  'Meditaciones',
                  Colors.purple.shade700,
                  () {
                    Navigator.pop(context);
                    _startMeditation();
                  },
                ),
                _buildDrawerItem(
                  Icons.analytics,
                  'Estadísticas',
                  Colors.orange.shade700,
                  () {
                    Navigator.pop(context);
                    _showProgress();
                  },
                ),
                _buildDrawerItem(
                  Icons.person,
                  'Perfil',
                  Colors.indigo.shade700,
                  () {
                    Navigator.pop(context);
                    _showProfile(context);
                  },
                ),
                const Divider(height: 40),
                _buildDrawerItem(
                  Icons.settings,
                  'Configuración',
                  Colors.grey.shade700,
                  () {
                    Navigator.pop(context);
                    _showSettingsDialog(context);
                  },
                ),
                _buildDrawerItem(
                  Icons.help_outline,
                  'Ayuda',
                  Colors.grey.shade700,
                  () {
                    Navigator.pop(context);
                    _showHelp();
                  },
                ),
              ],
            ),
          ),
          // Footer del Drawer
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Divider(),
                _buildDrawerItem(
                  Icons.logout,
                  'Cerrar Sesión',
                  Colors.red.shade700,
                  () {
                    Navigator.pop(context);
                    _logout();
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'Versión 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  // Sección de Bienvenida con Estadísticas
  Widget _buildWelcomeSection() {
    int completedHabits = dailyHabits.where((habit) => habit['completed'] == true).length;
    int totalHabits = dailyHabits.length;
    double progress = totalHabits > 0 ? completedHabits / totalHabits : 0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  widget.username.isNotEmpty ? widget.username[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola, ${widget.username}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getGreetingMessage(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progreso del día
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progreso de Hoy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$completedHabits de $totalHabits hábitos completados',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Acciones rápidas
  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionCard(
          'Meditar',
          Icons.self_improvement,
          Colors.purple,
          () => _startMeditation(),
        ),
        _buildQuickActionCard(
          'Hábitos',
          Icons.track_changes,
          Colors.green,
          () => _navigateToHabits(),
        ),
        _buildQuickActionCard(
          'Progreso',
          Icons.analytics,
          Colors.orange,
          () => _showProgress(),
        ),
        _buildQuickActionCard(
          'Perfil',
          Icons.person,
          Colors.blue,
          () => _showProfile(context),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Título de sección con icono
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Tarjetas de meditación mejoradas
  Widget _buildMeditationCards() {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: popularMeditations.length,
        itemBuilder: (context, index) {
          final meditation = popularMeditations[index];
          return Container(
            width: 170,
            margin: const EdgeInsets.only(right: 12),
            child: _buildEnhancedMeditationCard(meditation),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedMeditationCard(Map<String, dynamic> meditation) {
    return GestureDetector(
      onTap: () => _startSpecificMeditation(meditation),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: meditation['color'].withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con gradiente
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    meditation['color'].withOpacity(0.8),
                    meditation['color'],
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        meditation['category'],
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(
                      Icons.self_improvement,
                      size: 40,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  if (meditation['completed'])
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meditation['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meditation['subtitle'],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: meditation['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            meditation['duration'],
                            style: TextStyle(
                              fontSize: 10,
                              color: meditation['color'],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.play_circle_filled,
                          color: meditation['color'],
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Progreso de hábitos
  Widget _buildHabitProgress() {
    return Column(
      children: dailyHabits.map((habit) => _buildHabitProgressCard(habit)).toList(),
    );
  }

  Widget _buildHabitProgressCard(Map<String, dynamic> habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: habit['completed'] ? Colors.green.shade100 : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  habit['icon'],
                  color: habit['completed'] ? Colors.green.shade700 : Colors.blue.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit['subtitle'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _toggleHabit(habit),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: habit['completed'] ? Colors.green.shade100 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    habit['completed'] ? Icons.check : Icons.add,
                    color: habit['completed'] ? Colors.green.shade700 : Colors.grey.shade600,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Barra de progreso
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: habit['progress'],
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      habit['completed'] ? Colors.green.shade600 : Colors.blue.shade600,
                    ),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(habit['progress'] * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meta: ${habit['goal']}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                habit['duration'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tareas de hoy
  Widget _buildTodayTasks() {
    return Column(
      children: todayTasks.map((task) => _buildTaskCard(task)).toList(),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    Color priorityColor = task['priority'] == 'Alta' 
        ? Colors.red 
        : task['priority'] == 'Media' 
            ? Colors.orange 
            : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border(
          left: BorderSide(
            color: priorityColor,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleTask(task),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: task['completed'] ? Colors.green.shade600 : Colors.transparent,
                border: Border.all(
                  color: task['completed'] ? Colors.green.shade600 : Colors.grey.shade400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.check,
                color: task['completed'] ? Colors.white : Colors.transparent,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: task['completed'] ? TextDecoration.lineThrough : null,
                    color: task['completed'] ? Colors.grey.shade500 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      task['time'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task['priority'],
                        style: TextStyle(
                          fontSize: 10,
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta de motivación
  Widget _buildMotivationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.pink.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            '¡Sigue así!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getMotivationalMessage(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Métodos de utilidad
  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buenos días. ¡Comienza tu día con energía!';
    } else if (hour < 18) {
      return 'Buenas tardes. ¡Sigue con tus objetivos!';
    } else {
      return 'Buenas noches. ¡Relájate y descansa!';
    }
  }

  String _getMotivationalMessage() {
    final messages = [
      'Cada pequeño paso cuenta hacia tus objetivos',
      'La consistencia es la clave del éxito',
      'Hoy es un gran día para formar nuevos hábitos',
      'Tu bienestar mental es tu mayor tesoro',
      'Cada momento de mindfulness te acerca a la paz interior',
    ];
    return messages[DateTime.now().day % messages.length];
  }

  // Métodos de acción
  void _startMeditation() {
    // Implementar navegación a pantalla de meditación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciando sesión de meditación...'),
        backgroundColor: Colors.purple.shade600,
      ),
    );
  }

  void _navigateToHabits() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitTrackerScreen(username: widget.username),
      ),
    );
  }

  void _showProgress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.analytics, color: Colors.orange),
            SizedBox(width: 8),
            Text('Progreso General'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Resumen de esta semana:'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hábitos completados:'),
                Text('${dailyHabits.where((h) => h['completed']).length}/${dailyHabits.length}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Meditaciones:'),
                Text('${popularMeditations.where((m) => m['completed']).length}/${popularMeditations.length}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tareas completadas:'),
                Text('${todayTasks.where((t) => t['completed']).length}/${todayTasks.length}'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _startSpecificMeditation(Map<String, dynamic> meditation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(meditation['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.self_improvement,
              size: 64,
              color: meditation['color'],
            ),
            SizedBox(height: 16),
            Text(meditation['subtitle']),
            SizedBox(height: 8),
            Text('Duración: ${meditation['duration']}'),
            SizedBox(height: 8),
            Text('Nivel: ${meditation['category']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                meditation['completed'] = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('¡Meditación completada!'),
                  backgroundColor: Colors.green.shade600,
                ),
              );
            },
            child: Text('Comenzar'),
          ),
        ],
      ),
    );
  }

  void _toggleHabit(Map<String, dynamic> habit) {
    setState(() {
      habit['completed'] = !habit['completed'];
      if (habit['completed']) {
        habit['progress'] = 1.0;
      } else {
        habit['progress'] = (habit['progress'] as double) * 0.5;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          habit['completed'] 
              ? '¡Hábito completado! 🎉' 
              : 'Hábito marcado como pendiente'
        ),
        backgroundColor: habit['completed'] ? Colors.green.shade600 : Colors.orange.shade600,
      ),
    );
  }

  void _toggleTask(Map<String, dynamic> task) {
    setState(() {
      task['completed'] = !task['completed'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          task['completed'] 
              ? '¡Tarea completada! ✅' 
              : 'Tarea marcada como pendiente'
        ),
        backgroundColor: task['completed'] ? Colors.green.shade600 : Colors.blue.shade600,
      ),
    );
  }

  void _showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Crear Nuevo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.track_changes, color: Colors.blue.shade700),
              title: Text('Nuevo Hábito'),
              subtitle: Text('Crea un hábito diario'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddHabitScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.task_alt, color: Colors.green.shade700),
              title: Text('Nueva Tarea'),
              subtitle: Text('Agrega una tarea para hoy'),
              onTap: () {
                Navigator.pop(context);
                _addNewTask();
              },
            ),
            ListTile(
              leading: Icon(Icons.self_improvement, color: Colors.purple.shade700),
              title: Text('Sesión de Meditación'),
              subtitle: Text('Programa una meditación'),
              onTap: () {
                Navigator.pop(context);
                _startMeditation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        String taskTitle = '';
        String taskTime = '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}';
        String taskPriority = 'Media';
        
        return AlertDialog(
          title: Text('Nueva Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Título de la tarea',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => taskTitle = value,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: taskPriority,
                decoration: InputDecoration(
                  labelText: 'Prioridad',
                  border: OutlineInputBorder(),
                ),
                items: ['Alta', 'Media', 'Baja'].map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) => taskPriority = value ?? 'Media',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskTitle.isNotEmpty) {
                  setState(() {
                    todayTasks.add({
                      'title': taskTitle,
                      'subtitle': 'Personal',
                      'time': taskTime,
                      'priority': taskPriority,
                      'completed': false,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('¡Tarea creada exitosamente!'),
                      backgroundColor: Colors.green.shade600,
                    ),
                  );
                }
              },
              child: Text('Crear'),
            ),
          ],
        );
      },
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.notifications, color: Colors.blue.shade700),
            SizedBox(width: 8),
            Text('Notificaciones'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Hábito completado'),
              subtitle: Text('¡Felicidades por completar "Hacer Ejercicio"!'),
              trailing: Text('hace 2h'),
            ),
            ListTile(
              leading: Icon(Icons.self_improvement, color: Colors.purple),
              title: Text('Recordatorio de meditación'),
              subtitle: Text('Es hora de tu meditación matutina'),
              trailing: Text('hace 1h'),
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.orange),
              title: Text('¡Nuevo logro!'),
              subtitle: Text('Completaste 5 días consecutivos'),
              trailing: Text('ayer'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade700,
              child: Text(
                widget.username.isNotEmpty ? widget.username[0].toUpperCase() : 'U',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Perfil'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuario: ${widget.username}'),
            SizedBox(height: 8),
            Text('Hábitos activos: ${dailyHabits.length}'),
            SizedBox(height: 8),
            Text('Meditaciones completadas: ${popularMeditations.where((m) => m['completed']).length}'),
            SizedBox(height: 8),
            Text('Racha actual: 3 días'),
            SizedBox(height: 16),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                _showSettingsDialog(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context); // Regresa a login
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            const Text('Ayuda'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Cómo usar MindFlow?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('• Usa el menú hamburguesa para navegar'),
              Text('• Marca hábitos como completados tocando el ícono'),
              Text('• Selecciona meditaciones para comenzar'),
              Text('• Crea nuevos hábitos con el botón "+"'),
              Text('• Revisa tu progreso en Estadísticas'),
              SizedBox(height: 16),
              Text(
                'Consejos:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Mantén consistencia en tus hábitos'),
              Text('• Medita regularmente para mejor bienestar'),
              Text('• Revisa tu progreso diariamente'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Mostrar diálogo de configuración
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.settings, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            const Text('Configuración'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue.shade600),
              title: const Text('Perfil'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                _showProfile(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.green.shade600),
              title: const Text('Notificaciones'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Implementar lógica de notificaciones
                },
                activeColor: Colors.green.shade600,
              ),
            ),
            ListTile(
              leading: Icon(Icons.dark_mode, color: Colors.grey.shade600),
              title: const Text('Modo Oscuro'),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  // Implementar lógica de tema oscuro
                },
                activeColor: Colors.blue.shade600,
              ),
            ),
            ListTile(
              leading: Icon(Icons.language, color: Colors.orange.shade600),
              title: const Text('Idioma'),
              trailing: const Text('Español'),
              onTap: () {
                Navigator.pop(context);
                _showLanguageDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip, color: Colors.purple.shade600),
              title: const Text('Privacidad'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                _showPrivacyDialog();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇪🇸'),
              title: const Text('Español'),
              trailing: const Icon(Icons.check, color: Colors.green),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Text('🇺🇸'),
              title: const Text('English'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Text('🇫🇷'),
              title: const Text('Français'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacidad'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Política de Privacidad',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'MindFlow respeta tu privacidad. Tus datos se almacenan localmente y no se comparten con terceros.',
              ),
              SizedBox(height: 16),
              Text(
                'Datos que recopilamos:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('• Progreso de hábitos'),
              Text('• Preferencias de meditación'),
              Text('• Estadísticas de uso'),
              SizedBox(height: 16),
              Text(
                'Todos los datos permanecen en tu dispositivo y puedes eliminarlos en cualquier momento.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
