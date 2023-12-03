import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final List<String> imageAssets = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
    'assets/4.png',
    'assets/5.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: imageAssets
                .map((asset) => OnboardingPage(imageAsset: asset))
                .toList(),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: DotsIndicator(
              dotsCount: imageAssets.length,
              position: _currentPage.toInt(),
              decorator: DotsDecorator(
                size: Size.square(8.0),
                activeSize: Size.square(10.0),
                color: Colors.grey,
                activeColor: Colors.green,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("T");
                  },
                  child: Text('Skip'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < imageAssets.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    } else {
                      Navigator.of(context).pushReplacementNamed("T");
                    }
                  },
                  child: Text(_currentPage < imageAssets.length - 1
                      ? 'Avançar'
                      : 'Continuar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imageAsset;
  OnboardingPage({
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
