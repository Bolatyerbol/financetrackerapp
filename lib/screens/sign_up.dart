import 'package:flutter/material.dart';
import 'package:habit/screens/login_screen.dart';
import 'package:habit/services/auth_service.dart';
import 'package:habit/utils/appvalidator.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailNameController = TextEditingController();
  final _phoneNameController = TextEditingController();
  final _passwordNameController = TextEditingController();

  var authService = AuthService();
  var isLoader = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        'username': _userNameController.text,
        'email': _emailNameController.text,
        'password': _passwordNameController.text,
        'phone': _phoneNameController.text,
        'remainingAmount': 0,
        'totalCredit': 0,
        'totalDebit': 0
      };

      await authService.createUser(data, context);

      setState(() {
        isLoader = false;
      });
      // ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
      //   const SnackBar(
      //     content: Text('From submitted successfully'),
      //   ),
      // );
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
                    'Create new Account',
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
                  controller: _userNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(color: Colors.white),
                  decoration:
                      _buildInputDecoration('Username', Icons.person_2_rounded),
                  validator: appValidator.validateUsername,
                ),
                const SizedBox(
                  height: 16,
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
                  controller: _phoneNameController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                      _buildInputDecoration('Phone Number', Icons.phone),
                  validator: appValidator.validatePhoneNumber,
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
                            'Create',
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
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  child: const Text(
                    'Login',
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
