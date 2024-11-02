import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/database_helper.dart';
import 'listagem_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final secureStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    User? user = await _dbHelper.login(username, password);

    if (user != null) {
      await secureStorage.write(key: 'username', value: username);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListagemScreen()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login failed')));
    }
  }

  Future<void> _register() async {
    String username = usernameController.text;
    String password = passwordController.text;

    User newUser = User(username: username, password: password);
    await _dbHelper.register(newUser);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('User registered')));
  }
}
