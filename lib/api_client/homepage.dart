// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'recicla_app.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0; // Página atual do carrossel
  int _bottomNavBarIndex = 0; // Página atual da BottomNavigationBar
  late Timer _timer;
  String? _userName;
  String? _userEmail;

  // Define a lista de itens da barra de navegação
  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.event),
      label: 'Coletas',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Perfil',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });

    // Chama a função para buscar o nome do usuário (removido Firebase Auth)
    _fetchUserData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    // Simulando busca de dados do usuário (substitua por sua lógica)
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('nome') ?? 'Nome Padrão';
      _userEmail = prefs.getString('email') ?? 'email@example.com';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpa todos os dados do SharedPreferences

    Navigator.of(context)
        .pushReplacementNamed("T"); // Navega para a tela de transição
  }

  void _navigateToScreen(int index) {
    setState(() {
      _bottomNavBarIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed("F");
        break;
      case 1:
        Navigator.of(context).pushNamed("F");
        break;
      case 2:
        Navigator.of(context).pushNamed("F");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final carouselHeight = screenHeight / 2.6;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_userName ?? "Nome Padrão"),
              accountEmail: Text(_userEmail ?? "email@example.com"),
            ),
            const ListTile(
              leading: Icon(Icons.home),
              title: Text('Página Inicial'),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    _logout();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(backgroundColor: Colors.green),
      body: Column(
        children: [
          Container(
            height: carouselHeight,
            width: screenWidth,
            child: PageView.builder(
              controller: _pageController,
              itemCount: 3,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                final Uri? url;
                if (index == 0) {
                  url = Uri.parse(
                      'https://itapipoca.ce.gov.br/informa.php?id=574');
                } else if (index == 1) {
                  url = Uri.parse(
                      'https://itapipoca.ce.gov.br/informa.php?id=580');
                } else {
                  url = Uri.parse(
                      'https://itapipoca.ce.gov.br/informa.php?id=572');
                }
                return InformationPage(
                  imagePath: index == 0
                      ? 'assets/pag1.jpeg'
                      : (index == 1 ? 'assets/pag2.jpeg' : 'assets/pag3.jpeg'),
                  url: url,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.green : Colors.grey,
                ),
              );
            }),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 150.0,
                ),
              ),
            ),
          ),
          // Barra de navegação na parte inferior
          BottomNavigationBar(
            items: _bottomNavigationBarItems,
            currentIndex:
                _bottomNavBarIndex, // Usar _bottomNavBarIndex em vez de _currentPage
            onTap: (int index) {
              _navigateToScreen(index);
            },
          ),
        ],
      ),
    );
  }
}

class InformationPage extends StatelessWidget {
  final String imagePath;
  final Uri? url;

  const InformationPage({
    Key? key,
    required this.imagePath,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchURL(context, url!);
      },
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Não foi possível abrir a URL";
    }
    //  else {
    //   // Exiba uma mensagem de erro para o usuário
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Não foi possível abrir a URL.'),
    //     ),
    //   );
    // }
  }
}
