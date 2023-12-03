import 'package:flutter/material.dart';
import 'homepage.dart';
import 'preferences_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  String mensagemErro = '';

  Widget _body() {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: Icon(
                    Icons.email,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: Icon(
                    Icons.lock_rounded,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('H');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.green,
                ),
                child: Container(
                  width: 300,
                  height: 50,
                  alignment:
                      Alignment.center, // Centraliza o texto horizontalmente
                  child: const Text(
                    'Login',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Text(
                mensagemErro,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    await PreferencesService.setUserLoggedIn(true);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset("assets/7.png", fit: BoxFit.cover),
          ),
          _body(),
        ],
      ),
    );
  }
}
