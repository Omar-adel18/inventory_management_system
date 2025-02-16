import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';

import '../utils/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final authService = AuthService();
  final _usernameController = TextEditingController();
  final _userRoleController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late bool _passwordVisible;

  void signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final username = _usernameController.text;
    final userRole = _userRoleController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signUpWithEmailPassword(
          username, userRole, email, password);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error : ${e}')));
        log(e.toString());
      }
    }
  }


  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Blurred Background Image
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
            // Sign-Up Form
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildInputField(
                          hintText: 'User Name',
                          icon: Icons.person,
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'User Name is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        _buildInputField(
                          hintText: 'User Role',
                          icon: Icons.assignment_ind,
                          controller: _userRoleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'User Role is required';
                            }
                            if (value != 'admin' ||
                                value != 'staff' ||
                                value != 'viewer') {
                              return 'User Role must be admin, staff, or viewer';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
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
                        SizedBox(height: 15),
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
                        SizedBox(height: 25),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            onPressed: signUp,
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
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?  ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Login',
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
            ),
          ],
        ),
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
