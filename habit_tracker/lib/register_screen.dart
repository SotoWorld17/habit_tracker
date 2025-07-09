// lib/register_screen.dart

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'country_list.dart';
import 'habit_tracker_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController     = TextEditingController();
  final _usernameController = TextEditingController();
  double _age = 25;

  // Ahora puede ser null hasta que carguemos la lista y el valor guardado
  String? _country;
  List<String> _countries = [];

  List<String> selectedHabits = [];
  final List<String> availableHabits = [
    'Despertarse temprano',
    'Hacer ejercicio',
    'Beber agua',
    'Meditar',
    'Leer un libro',
    'Practicar gratitud',
    'Dormir 8 horas',
    'Comer sano',
    'Escribir un diario',
    'Caminar 10.000 pasos'
  ];

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

  static const _kNameKey          = 'name';
  static const _kUsernameKey      = 'username';
  static const _kAgeKey           = 'age';
  static const _kCountryKey       = 'country';
  static const _kHabitsMapKey     = 'selectedHabitsMap';

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _loadCountries(); // carga la lista desde API
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text     = prefs.getString(_kNameKey)     ?? '';
    _usernameController.text = prefs.getString(_kUsernameKey) ?? '';
    _age                     = prefs.getDouble(_kAgeKey)      ?? 25;
    final savedHabitsMap     = prefs.getString(_kHabitsMapKey);
    if (savedHabitsMap != null) {
      final Map<String, dynamic> map = jsonDecode(savedHabitsMap);
      selectedHabits = map.keys.toList();
    }
    // No cargamos aún _country, lo haremos cuando tengamos la lista de _countries
    setState(() {});
  }

  Future<void> _loadCountries() async {
    try {
      final list = await fetchCountries();
      // elimina duplicados y ordena
      final unique = list.toSet().toList()..sort();
      setState(() {
        _countries = unique;
      });
      // si había un país guardado, lo recuperamos y validamos
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_kCountryKey);
      if (saved != null && unique.contains(saved)) {
        setState(() => _country = saved);
      }
    } catch (e) {
      _showToast('Error al obtener países');
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _register() async {
    final name     = _nameController.text;
    final username = _usernameController.text;

    if (name.isEmpty || username.isEmpty || _country == null || selectedHabits.isEmpty) {
      _showToast('Completa todos los campos, incluyendo país y hábitos');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    // asignar colores aleatorios
    final random     = Random();
    final colorKeys  = _habitColors.keys.toList();
    final Map<String, String> map = {};
    for (var habit in selectedHabits) {
      final col = _habitColors[colorKeys[random.nextInt(colorKeys.length)]]!;
      map[habit] = col.value.toRadixString(16);
    }

    await prefs.setString(_kNameKey, name);
    await prefs.setString(_kUsernameKey, username);
    await prefs.setDouble(_kAgeKey, _age);
    await prefs.setString(_kCountryKey, _country!);
    await prefs.setString(_kHabitsMapKey, jsonEncode(map));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HabitTrackerScreen(username: username),
      ),
    );
  }

  void _toggleHabit(String h) {
    setState(() {
      if (selectedHabits.contains(h)) selectedHabits.remove(h);
      else selectedHabits.add(h);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField(_nameController, 'Nombre', Icons.person),
              const SizedBox(height: 12),
              _buildField(_usernameController, 'Nombre de usuario', Icons.alternate_email),
              const SizedBox(height: 12),
              Text('Edad: ${_age.round()}', style: const TextStyle(color: Colors.white, fontSize: 18)),
              Slider(
                value: _age, min: 21, max: 100, divisions: 79,
                activeColor: Colors.blue.shade300, inactiveColor: Colors.blue.shade100,
                onChanged: (v) => setState(() => _age = v),
              ),
              const SizedBox(height: 12),

              // aquí el FutureBuilder sólo mostrará el dropdown cuando _countries NO esté vacío
              _countries.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _buildCountryDropdown(),

              const SizedBox(height: 16),
              const Text('Selecciona tus hábitos', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: availableHabits.map((h) {
                  final sel = selectedHabits.contains(h);
                  return ChoiceChip(
                    label: Text(h),
                    selected: sel,
                    onSelected: (_) => _toggleHabit(h),
                    selectedColor: Colors.blue.shade600,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(color: sel ? Colors.white : Colors.blue.shade700),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Registrar', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(border: InputBorder.none),
        isExpanded: true,
        items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
        value: _country,
        onChanged: (v) => setState(() => _country = v),
        validator: (v) => v == null ? 'Selecciona un país' : null,
      ),
    );
  }
}
