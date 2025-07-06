import 'package:flutter/material.dart';

/// Pantalla de detalles para mostrar información específica de un hábito
class HabitDetailScreen extends StatelessWidget {
  final Map<String, dynamic> habit;
  
  const HabitDetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    // Obtener información del hábito
    final String title = habit['title'] ?? 'Hábito sin título';
    final String description = habit['description'] ?? 'Sin descripción disponible';
    final String color = habit['color'] ?? 'FF5722';
    final bool isCompleted = habit['isCompleted'] ?? false;
    final int streak = habit['streak'] ?? 0;
    final String category = habit['category'] ?? 'General';
    final String difficulty = habit['difficulty'] ?? 'Medio';
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _getColorFromHex(color),
        title: Text(
          'Detalles del Hábito',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _getColorFromHex(color),
              _getColorFromHex(color).withOpacity(0.1),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado principal del hábito
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icono del hábito
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        _getHabitIcon(title),
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Título del hábito
                    Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Estado del hábito
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isCompleted ? 'Completado Hoy' : 'Pendiente',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Información detallada
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Descripción
                    _buildDetailRow('Descripción', description, Icons.description),
                    const SizedBox(height: 20),
                    
                    // Estadísticas
                    _buildDetailRow('Racha Actual', '$streak días', Icons.local_fire_department),
                    const SizedBox(height: 20),
                    
                    _buildDetailRow('Categoría', category, Icons.category),
                    const SizedBox(height: 20),
                    
                    _buildDetailRow('Dificultad', difficulty, Icons.fitness_center),
                    const SizedBox(height: 20),
                    
                    // Progreso semanal (simulado)
                    _buildWeeklyProgress(),
                  ],
                ),
              ),
              
              // Botones de acción
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Botón para marcar como completado/incompleto
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Mostrar confirmación
                          _showCompletionDialog(context, title, isCompleted);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCompleted ? Colors.orange : Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(isCompleted ? Icons.refresh : Icons.check),
                            const SizedBox(width: 8),
                            Text(
                              isCompleted ? 'Marcar como Pendiente' : 'Marcar como Completado',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Botón para volver a la lista
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _getColorFromHex(color)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back, color: _getColorFromHex(color)),
                            const SizedBox(width: 8),
                            Text(
                              'Volver a la Lista',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _getColorFromHex(color),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye una fila de detalles con icono, título y valor
  Widget _buildDetailRow(String title, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye el widget de progreso semanal
  Widget _buildWeeklyProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
            ),
            const SizedBox(width: 12),
            const Text(
              'Progreso Semanal',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['L', 'M', 'X', 'J', 'V', 'S', 'D'].map((day) {
            final isCompleted = ['L', 'M', 'X'].contains(day); // Simulado
            return Column(
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Muestra un diálogo de confirmación para cambiar el estado del hábito
  void _showCompletionDialog(BuildContext context, String title, bool isCompleted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Acción'),
          content: Text(
            isCompleted 
                ? '¿Marcar "$title" como pendiente?'
                : '¿Marcar "$title" como completado?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isCompleted 
                          ? 'Hábito marcado como pendiente'
                          : '¡Hábito completado! 🎉',
                    ),
                    backgroundColor: isCompleted ? Colors.orange : Colors.green,
                  ),
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  /// Convierte un color hexadecimal a Color
  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse('0x$hexColor'));
  }

  /// Obtiene el icono apropiado para el hábito basado en su título
  IconData _getHabitIcon(String title) {
    final titleLower = title.toLowerCase();
    
    if (titleLower.contains('ejercicio') || titleLower.contains('deporte')) {
      return Icons.fitness_center;
    } else if (titleLower.contains('agua') || titleLower.contains('beber')) {
      return Icons.local_drink;
    } else if (titleLower.contains('leer') || titleLower.contains('libro')) {
      return Icons.menu_book;
    } else if (titleLower.contains('meditar') || titleLower.contains('meditación')) {
      return Icons.self_improvement;
    } else if (titleLower.contains('dormir') || titleLower.contains('sueño')) {
      return Icons.bedtime;
    } else if (titleLower.contains('comer') || titleLower.contains('comida')) {
      return Icons.restaurant;
    } else if (titleLower.contains('caminar') || titleLower.contains('pasos')) {
      return Icons.directions_walk;
    } else {
      return Icons.track_changes;
    }
  }
}
