import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'solicitacaopage.dart';
import 'cadastro_page.dart';
import 'homepage.dart';
import 'loginpage.dart';

import 'tela_transicao.dart';

class AppWidget extends StatelessWidget {
  final bool userLoggedIn;
  final ThemeData tema = ThemeData();

  AppWidget({Key? key, required this.userLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: tema.copyWith(
          colorScheme: tema.colorScheme.copyWith(
        primary: Colors.green,
        secondary: Colors.white,
      )),
      initialRoute: userLoggedIn ? "H" : "/",
      routes: {
        "/": (context) => OnboardingScreen(),
        "T": (context) => TransitionPage(),
        "C": (context) => RegistrationPage(),
        "L": (context) => LoginPage(),
        "H": (context) => HomePage(),
        "F": (context) => FormularioPage(),
      },
    );
  }
}
