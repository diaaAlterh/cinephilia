import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'movies_screen.dart';

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

  Widget _indicator(bool isActive) {
    return Container(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 200),
        child: Image.asset(
          'images/logo.png',
          color: (isActive) ? Colors.white : Colors.white.withOpacity(0.5),
          height: 20,
          width: 20,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
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
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Image(
                            image: AssetImage(
                              'images/onbording1.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 100),
                            child: Text(
                              'Download the Movie you like',
                              textAlign: TextAlign.center,

                              style:
                              TextStyle(color: Colors.white, fontSize: 25),
                            ))
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Image(
                            image: AssetImage(
                              'images/onbording2.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 100),
                            child: Text(
                              'Know the movie is not worth Watching',
                              textAlign: TextAlign.center,
                              style:
                              TextStyle(color: Colors.white, fontSize: 25),
                            ))
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Image(
                            image: AssetImage(
                              'images/onbording3.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 100),
                            child: Text(
                              'Real-time updates movie Trailer',
                              textAlign: TextAlign.center,

                              style:
                              TextStyle(color: Colors.white, fontSize: 25),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ),
              _currentPage != _numPages - 1
                  ? Container(
                width: 190,
                height: 54,
                // color: Colors.white,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white)),
                margin: EdgeInsets.only(bottom: 100),
                child: TextButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ],
                  ),
                ),
              )
                  : Container(
                width: 190,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.orange, Colors.red]),
                ),
                margin: EdgeInsets.only(bottom: 100),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => MoviesScreen()));
                  },
                  child: Center(
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}