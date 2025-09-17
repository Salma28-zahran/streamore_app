import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  static const String routeName = "/onboarding";

  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/onboarding1.png',
      'text': 'assets/images/text1.png',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'text': 'assets/images/text2.png',
    },
    {
      'image': 'assets/images/onboarding3.png',
      'text': 'assets/images/text3.png',
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }
  void previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }
  void _goToSignIn() {
    Navigator.pushNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 150),
                  ColorFiltered(
                    colorFilter:
                    ColorFilter.mode(Colors.white, BlendMode.saturation),
                    child: Image.asset(_pages[index]['image']!),
                  ),
                  SizedBox(height: 20),
                  Image.asset(_pages[index]['text']!),
                ],
              );
            },
          ),

          // Skip Button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _goToSignIn,
              child: Text("Skip", style: TextStyle(color: Colors.black)),
            ),
          ),

          // Dots Indicator + Buttons
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child : TextButton(
                          onPressed: _currentPage == 0 ? null : previousPage,
                          child:
                     Text(
                        "Prev",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                            (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.black
                                : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _currentPage == _pages.length - 1
                          ? TextButton(
                        onPressed: _goToSignIn,
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                              color: Color(0xff0080FF), fontSize: 16),
                        ),
                      )
                          : TextButton(
                        onPressed: _nextPage,
                        child: Text(
                          "Next",
                          style: TextStyle(
                              color: Color(0xff0080FF), fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
