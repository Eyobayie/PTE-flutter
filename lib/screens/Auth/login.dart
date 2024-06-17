import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/main.dart';
import 'package:parent_teacher_engagement_app/services/Auth/login.dart';

class LoginDemo extends StatefulWidget {
  static const loginRoute="login-route";

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
   String _username='';
   String _password="";
    final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameControlller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  void _login() async {

    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
        final String enteredUsername = _usernameControlller.text.trim();
        final String enteredPassword= _passwordController.text;
      try {
        final user = await LoginService.login(enteredUsername, enteredPassword);
        if (user != null) {
          // Navigate to the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MyHomePage(title: 'Home'),
            ),
          );
        }
      } catch (e) {
        // Handle login error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $e'),
          ),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Container for background image with AspectRatio
            AspectRatio(
              aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/edusure.png'), // Ensure the path is correct
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Form elements
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30), // Adjust padding as needed
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: AppBarConstants.backgroundColor),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                focusNode: _usernameFocusNode,
                maxLines: 1,
                controller: _usernameControlller,
                onSaved: (value) {
                  _username = value!;
                },
              ),
                    const SizedBox(height: 15),
                TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: AppBarConstants.backgroundColor),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
                focusNode: _passwordFocusNode,
                maxLines: 1,
                controller: _passwordController,
                onSaved: (value) {
                  _password = value!;
                },
              ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                color: AppBarConstants.backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _login,
                child: const Text(
                  'Login',
                  style: AppBarConstants.textStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
