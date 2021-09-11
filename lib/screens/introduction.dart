import 'package:concoin/screens/coin_flip_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  void _finishIntro(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CoinFlipScreen()));
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _finishIntro(context),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 600.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: -30,
                            child: Image(
                              height: 300,
                              image: AssetImage(
                                'assets/handcoin.png',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Spacer(),
                                Expanded(
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Welcome!',
                                          style: GoogleFonts.poppins(fontSize: 40),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.0),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Thank you for installing ConCoin, the rigged coin toss app!',
                                        style: GoogleFonts.poppins(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],),
                                )

                              ],
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: -20,
                            child: Image(
                              height: 300,
                              image: AssetImage(
                                'assets/toss.png',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Spacer(),
                                Expanded(
                                  child: Column(children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'How to use?',
                                        style: GoogleFonts.poppins(fontSize: 40),
                                      ),
                                    ),
                                    SizedBox(height: 15.0),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '• Swipe up to get tails ☝\n• Swipe down to get heads👇 \n• Double tap to get a random result✌ ',
                                        style: GoogleFonts.poppins(fontSize: 20,height: 2),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ],),
                                )

                              ],
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 30,
                            child: Image(
                              height: 300,
                              image: AssetImage(
                                'assets/responsible.png',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Spacer(),
                                Expanded(
                                  child: Column(children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Use Responsibly!',
                                        style: GoogleFonts.poppins(fontSize: 40),
                                      ),
                                    ),
                                    SizedBox(height: 15.0),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'This app is for entertainment purposes only.\n (This landing screen will not appear again).',
                                        style: GoogleFonts.poppins(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],),
                                )

                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              color: Colors.blue,
              padding: EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width * 0.7,
                      color: Colors.blue,
                      child: ElevatedButton(
                          onPressed: () => _finishIntro(context),
                          child: Text(
                            'Let\'s Go',
                            style: TextStyle(
                                fontFamily: 'Montserrat', color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.black87),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ))),
                ],
              ),
            )
          : Text(''),
    );
  }
}
