import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:inventory_management_system/screens/home_page.dart';
import 'package:inventory_management_system/screens/signup_page.dart';
import 'package:inventory_management_system/utils/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late bool _passwordVisible;
  late bool _rememberMe;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _rememberMe = false;
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('KeepMeLoggedIn') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('KeepMeLoggedIn', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('KeepMeLoggedIn', false);
    }
  }

  void login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      await authService.signInWithEmailPassword(email, password);
      log(authService.getCurrentUserEmail().toString());
      await _saveCredentials(); // Save credentials if "Remember Me" is checked
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://i.pinimg.com/474x/2e/d0/42/2ed042a7094f81e9eb81ea5740be4a50.jpg',
            fit: BoxFit.cover,
          ),
          // Blur Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 2.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Login Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Title
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Email Field
                    _buildInputField(
                      hintText: 'Email',
                      icon: Icons.email,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    _buildInputField(
                      hintText: 'Password',
                      icon: Icons.lock,
                      isPassword: !_passwordVisible,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Forgot Password Link
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Remember Me Checkbox and Text
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _rememberMe = !_rememberMe;
                              });
                            },
                            child: Row(
                              children: [
                                Theme(
                                  data: ThemeData(unselectedWidgetColor: Colors.white),
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value!;
                                        log('_rememberMe$_rememberMe');
                                      });
                                    },
                                    activeColor: Colors.blueAccent,
                                    checkColor: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Remember Me",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login Button with Animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          shadowColor: Colors.blueAccent.withOpacity(0.5),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?  ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Input Field Widget
  Widget _buildInputField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    Widget? suffixIcon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          color: Colors.orange, // Error text color
          fontSize: 15,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        suffixIcon: suffixIcon,
      ),
    );
  }
}