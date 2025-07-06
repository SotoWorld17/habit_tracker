import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para los campos de texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Paso 2: Función para validar entrada
  bool validateForm() {
    // Verificar que todos los campos requeridos estén completos
    if (emailController.text.trim().isEmpty) {
      _showErrorDialog('El correo electrónico es obligatorio');
      return false;
    }
    
    if (passwordController.text.trim().isEmpty) {
      _showErrorDialog('La contraseña es obligatoria');
      return false;
    }
    
    // Verificar formato del correo electrónico
    if (!_isValidEmail(emailController.text.trim())) {
      _showErrorDialog('Por favor ingresa un correo electrónico válido');
      return false;
    }
    
    return true;
  }

  // Función para validar el formato del email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Paso 3: Función para verificar credenciales
  Future<void> authenticateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Obtener datos almacenados
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');
    bool? isRegistered = prefs.getBool('isRegistered');
    
    // Verificar si hay usuarios registrados
    if (isRegistered != true) {
      _showErrorDialog('No hay usuarios registrados. Por favor regístrate primero.');
      return;
    }
    
    // Comparar credenciales
    if (savedEmail == emailController.text.trim() && 
        savedPassword == passwordController.text.trim()) {
      // Login exitoso
      _showSuccessDialog('¡Inicio de sesión exitoso!');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showErrorDialog('Correo electrónico o contraseña incorrectos');
    }
  }

  // Paso 4: Función para manejar presión del botón de inicio de sesión
  Future<void> handleLogin() async {
    if (!validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await authenticateUser();
    } catch (e) {
      _showErrorDialog('Error al iniciar sesión: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Éxito'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                '¡Bienvenido de vuelta!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Inicia sesión para continuar',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Paso 1: Implementación exacta según requisitos
              Column(
                children: [
                  // Campo de correo electrónico
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Ingresa tu correo electrónico',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Campo de contraseña
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Ingresa tu contraseña',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // Botón de inicio de sesión
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Enlace para registro usando TextButton
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      "¿No tienes una cuenta? Regístrate",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // Enlace para "¿Olvidaste tu contraseña?" usando GestureDetector
                  GestureDetector(
                    onTap: () {
                      // Lógica para recuperar contraseña
                      _showErrorDialog('Funcionalidad de recuperación de contraseña próximamente');
                    },
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
