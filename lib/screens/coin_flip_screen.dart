import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';



class CoinFlipScreen extends StatefulWidget {
  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen> {
  late bool _showFrontSide;
  double _distanceFromBottom =
      90; // controls coin's distance from bottom of screen
  bool _isActive = false; // is the coin being flipped right now
  bool _soundOn = true;
  String _face = ''; // initialize string face
  final List<String> faces = ['heads', 'tails'];
  String cartoon = '';
  double _textOpacity = 0; // opacity of the result text
  int _flip_duration = 1800;


  final player = AudioCache();

  @override
  void initState() {
    super.initState();
    _showFrontSide = true;
  }

  @override
  void dispose() {
    super.dispose();
    player.clearAll();
  }

  void _restart() {
    setState(() {
      _distanceFromBottom = 90;
      _textOpacity = 0.0;
      _isActive = false;
    });
  }

  void _soundOnOff() {
    setState(() {
      _soundOn = !_soundOn;
    });
  }

  void _coinTypeChange() {
    setState(() {
      if (cartoon == '') {
        cartoon = 'cartoon';
      } else {
        cartoon = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // check if swipe down.
        if (details.delta.dy > 0 && !_isActive) {
          print('swipe down | heads');
          _isActive = true; // the coin is being flipped..
          _flipCoin('heads');
        }
        // check if swipe up.
        if (details.delta.dy < 0 && !_isActive) {
          print('swipe up | tails');
          _isActive = true; // the coin is being flipped..
          _flipCoin('tails');
        }
      },
      onDoubleTap: () {
        // Just in case you actually want a random coin toss
        // double tap the Coin
        if (!_isActive) {
          _isActive = true; // the coin is being flipped..
          int faceIndex = Random().nextInt(faces.length);
          _flipCoin(faces[faceIndex]);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                  left: 10,
                  top: 10,
                  child: _soundOn
                      ? GestureDetector(
                          onTap: _soundOnOff,
                          child: Icon(
                            Icons.volume_up,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                        )
                      : GestureDetector(
                          onTap: _soundOnOff,
                          child: Icon(
                            Icons.volume_off,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                        )),
              Positioned(
                  left: 10,
                  top: 60,
                  child: cartoon == ''
                      ? GestureDetector(
                          onTap: _coinTypeChange,
                          child: Icon(
                            Icons.monetization_on_outlined,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                        )
                      : GestureDetector(
                          onTap: _coinTypeChange,
                          child: Icon(
                            Icons.monetization_on_sharp,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                        )),
              AnimatedPositioned(
                //This is where the coin animation lives
                duration: Duration(seconds: 2),
                curve: Curves.bounceOut,
                bottom: _distanceFromBottom,
                right: MediaQuery.of(context).size.width * 0.31,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: _flip_duration),
                  transitionBuilder: __transitionBuilder,
                  child: _showFrontSide ? _buildHeads() : _buildTails(),
                  switchOutCurve: Curves.easeIn.flipped,
                ),
              ),
              Align(
                //This is the text that gets displayed after the flip
                child: AnimatedOpacity(
                  child: Text(
                    '$_face'.toUpperCase(),
                    style: GoogleFonts.poppins(
                        color: Colors.blue[500],
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3),
                  ),
                  duration: Duration(seconds: 1),
                  opacity: _textOpacity,
                ),
              ),
              Align(
                //This is the button to replay
                alignment: Alignment(-0.01, 0.8),
                child: AnimatedOpacity(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        primary: Colors.blue, // <-- Button color
                        onPrimary: Colors.white, // <-- Splash color
                      ),
                      child: Icon(
                        Icons.replay,
                        size: 40,
                      ),
                      onPressed: _restart,
                    ),
                  ),
                  duration: Duration(seconds: 1),
                  opacity: _textOpacity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _flipCoin(String face) async {
    setState(() {
      if (_soundOn) {
        player.play('flip.wav');
      }
      _distanceFromBottom = 450;
      _showFrontSide = !_showFrontSide;
      _face = face;
    });
    Future.delayed(Duration(milliseconds: 3000)).then((value) {
      if (_soundOn) {
        player.play('$face.mp3');
      }
      setState(() {
        _textOpacity = 1.0;
      });
    });
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi * 12, end: 0.0).animate(animation);

    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget!.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.01;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value * 16, pi / 2) : rotateAnim.value;
        if (_face == 'heads') {
          return Transform(
            transform: (Matrix4.rotationX(value)),
            child: (rotateAnim.value < 0.5 ||
                    value > 1.4 && value < 1.5 ||
                    (value > pi / 4 && value < pi / 2) ||
                    (value > pi * 3 && value < pi * 4) ||
                    (value > pi * 5 && value < pi * 6) ||
                    (value > pi * 8 && value < pi * 9))
                ? _buildHeads()
                : _buildTails(),
            alignment: Alignment.center,
          );
        } else {
          return Transform(
            transform: (Matrix4.rotationX(value)),
            child: (rotateAnim.value < 1 ||
                    value > 1.4 && value < 1.5 ||
                    (value > pi / 4 && value < pi / 2) ||
                    (value > pi * 3 && value < pi * 4) ||
                    (value > pi * 5 && value < pi * 6) ||
                    (value > pi * 8 && value < pi * 9))
                ? _buildTails()
                : _buildHeads(),
            alignment: Alignment.center,
          );
        }
      },
    );
  }

  Widget _buildHeads() {
    return __buildLayout(
      key: ValueKey(true),
      faceName: "Heads",
    );
  }

  Widget _buildTails() {
    return __buildLayout(
      key: ValueKey(false),
      faceName: "Tails",
    );
  }

  Widget __buildLayout({required Key key, required String faceName}) {
    return Material(
        color: Colors.transparent,
        shape: CircleBorder(),
        shadowColor: Colors.blue,
        elevation: 10,
        key: key,
        child: Container(
            height: 150,
            child: Center(
              child: faceName == "Heads"
                  ? Image.asset('assets/${cartoon}heads.png')
                  : Image.asset('assets/${cartoon}tails.png'),
            )));
  }
}
