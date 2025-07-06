import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'habit_tracker_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  double _age = 25; // Edad predeterminada establecida en 25
  String _country = 'Estados Unidos';
  List<String> _countries = [];
  List<String> selectedHabits = [];
  List<String> availableHabits = [
    'Despertar Temprano',
    'Hacer Ejercicio',
    'Beber Agua',
    'Meditar',
    'Leer un Libro',
    'Practicar Gratitud',
    'Dormir 8 Horas',
    'Comer Saludable',
    'Escribir un Diario',
    'Caminar 10,000 Pasos'
  ];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    List<String> subsetCountries = [
      'Estados Unidos',
      'España',
      'Canadá',
      'Reino Unido',
      'Australia',
      'India',
      'Alemania',
      'Francia',
      'Japón',
      'China',
      'Brasil',
      'Sudáfrica'
    ];
    setState(() {
      _countries = subsetCountries;
      _countries.sort();
      _country = _countries.isNotEmpty ? _countries[0] : 'Estados Unidos';
    });
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

  void _register() async {
    final name = _nameController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    
    if (username.isEmpty || name.isEmpty || password.isEmpty) {
      _showToast('Por favor, completa todos los campos');
      return;
    }
    
    if (password.length < 6) {
      _showToast('La contraseña debe tener al menos 6 caracteres');
      return;
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HabitTrackerScreen(username: username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'Registro',
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputField(_nameController, 'Nombre', Icons.person),
                const SizedBox(height: 10),
                _buildInputField(
                    _usernameController, 'Nombre de Usuario', Icons.alternate_email),
                const SizedBox(height: 10),
                _buildPasswordField(),
                const SizedBox(height: 10),
                Text('Edad: ${_age.round()}',
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
                Slider(
                  value: _age,
                  min: 14,
                  max: 100,
                  divisions: 79,
                  activeColor: Colors.blue.shade600,
                  inactiveColor: Colors.blue.shade300,
                  onChanged: (double value) {
                    setState(() {
                      _age = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildCountryDropdown(),
                const SizedBox(height: 10),
                const Text('Selecciona tus Hábitos',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: availableHabits.map((habit) {
                    final isSelected = selectedHabits.contains(habit);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedHabits.remove(habit);
                          } else {
                            selectedHabits.add(habit);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.blue.shade600 : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade700),
                        ),
                        child: Text(
                          habit,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.blue.shade700,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                    ),
                    child: const Text(
                      'Registrar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
          hintText: 'Contraseña',
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButton<String>(
        value: _country,
        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
        isExpanded: true,
        underline: const SizedBox(),
        items: _countries.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _country = newValue!;
          });
        },
      ),
    );
  }
}
