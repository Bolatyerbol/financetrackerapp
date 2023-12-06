import 'package:flutter/material.dart';
import 'package:habit/screens/sign_up.dart';
import 'package:habit/services/auth_service.dart';
import 'package:habit/utils/appvalidator.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailNameController = TextEditingController();
  final _passwordNameController = TextEditingController();

  var isLoader = false;

  var authService = AuthService();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        'email': _emailNameController.text,
        'password': _passwordNameController.text,
      };

      await authService.login(data, context);

      setState(
        () {
          isLoader = false;
        },
      );
    }
  }

  var appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252634),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                const SizedBox(
                  width: 250,
                  child: Text(
                    'Login Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _emailNameController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                      _buildInputDecoration('Email', Icons.email_rounded),
                  validator: appValidator.validateEmail,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _passwordNameController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration('Password', Icons.lock),
                  validator: appValidator.validatePassword,
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 91, 27, 1),
                    ),
                    onPressed: () {
                      isLoader ? print('Loading') : _submitForm();
                    },
                    child: isLoader
                        ? const Center(child: CircularProgressIndicator())
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpView(),
                      ),
                    );
                  },
                  child: const Text(
                    'Create new account',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 91, 27, 1), fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
      fillColor: const Color(0xAA494A59),
      filled: true,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF949494),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      labelStyle: const TextStyle(color: Color(0xFF949494)),
      labelText: label,
      suffixIcon: Icon(
        suffixIcon,
        color: const Color(0xFF949494),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
