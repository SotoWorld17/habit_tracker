import 'package:flutter/material.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitController = TextEditingController();
  Color selectedColor = Colors.amber; // Color predeterminado
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};

  final Map<String, Color> _habitColors = {
    'Amber': Colors.amber,
    'Red Accent': Colors.redAccent,
    'Light Blue': Colors.lightBlue,
    'Light Green': Colors.lightGreen,
    'Purple Accent': Colors.purpleAccent,
    'Orange': Colors.orange,
    'Teal': Colors.teal,
    'Deep Purple': Colors.deepPurple,
  };

  String selectedColorName = 'Amber'; // Nombre del color predeterminado

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    setState(() {
      // Hábitos codificados para demostración
      selectedHabitsMap = {
        'Workout': 'FF5733', // Color en hex (por ejemplo, Amber)
        'Meditate': 'FF33A1',
        'Read a Book': '33FFA1',
        'Drink Water': '3380FF',
        'Practice Gratitude': 'FFC300'
      };
      completedHabitsMap = {
        'Wake Up Early': 'FF5733',
        'Journal': 'DAF7A6'
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    // Combina ambos mapas para mostrar, asegurando que no haya duplicados
    Map<String, String> allHabitsMap = {...selectedHabitsMap, ...completedHabitsMap};

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'Configurar Hábitos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _habitController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Hábito',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.track_changes),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Seleccionar Color:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                value: selectedColorName,
                isExpanded: true,
                underline: const SizedBox(),
                items: _habitColors.keys.map((String colorName) {
                  return DropdownMenuItem<String>(
                    value: colorName,
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _habitColors[colorName],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        colorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedColorName = newValue!;
                    selectedColor = _habitColors[selectedColorName]!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_habitController.text.isNotEmpty) {
                    setState(() {
                      // Agrega el nuevo hábito al selectedHabitsMap con el color elegido
                      selectedHabitsMap[_habitController.text] =
                          selectedColor.value.toRadixString(16);
                      _habitController.clear();
                      selectedColorName = 'Amber'; // Restablecer a predeterminado
                      selectedColor = _habitColors[selectedColorName]!;
                    });
                    
                    // Mostrar confirmación
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('¡Hábito agregado exitosamente!'),
                        backgroundColor: Colors.green.shade600,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    // Mostrar error si el campo está vacío
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Por favor, ingresa un nombre para el hábito'),
                        backgroundColor: Colors.red.shade600,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_circle_outline),
                    SizedBox(width: 8),
                    Text(
                      'Agregar Hábito',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Hábitos Existentes:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: allHabitsMap.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sentiment_satisfied_alt,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No hay hábitos aún',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Agrega tu primer hábito para comenzar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: allHabitsMap.entries.map((entry) {
                        final habitName = entry.key;
                        final habitColor = _getColorFromHex(entry.value);
                        final isCompleted = completedHabitsMap.containsKey(habitName);
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          elevation: 2,
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: habitColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: habitColor.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isCompleted ? Icons.check : Icons.track_changes,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              habitName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                decoration: isCompleted ? TextDecoration.lineThrough : null,
                                color: isCompleted ? Colors.grey.shade600 : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              isCompleted ? 'Completado ✅' : 'Pendiente 📝',
                              style: TextStyle(
                                color: isCompleted ? Colors.green.shade600 : Colors.orange.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmation(context, habitName);
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String habitName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Hábito'),
          content: Text('¿Estás seguro de que quieres eliminar "$habitName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedHabitsMap.remove(habitName);
                  completedHabitsMap.remove(habitName);
                });
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Hábito "$habitName" eliminado'),
                    backgroundColor: Colors.orange.shade600,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Agregar opacidad si no está incluida.
    }
    return Color(int.parse('0x$hexColor'));
  }
}
