import 'package:flutter/material.dart';

class TransitionPage extends StatefulWidget {
  const TransitionPage({super.key});

  @override
  State<TransitionPage> createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage> {
  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 100,
          top: 10,
          right: 100,
          bottom: 10,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: 600,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("L");
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  backgroundColor: Colors.green,
                ),
                child: Row(
                  children: [
                    Icon(Icons.mail),
                    SizedBox(width: 3),
                    Text(
                      'Continuar com e-mail',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("C");
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Não tem uma conta? Clique aqui',
                        style: TextStyle(fontSize: 7.5),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset("assets/8.png", fit: BoxFit.cover),
          ),
          _body()
        ],
      ),
    );
  }
}
