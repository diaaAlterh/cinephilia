import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 80, bottom: 30),
              child: CircleAvatar(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: Image.asset(
                      'images/me.jpg',
                      height: 500,
                      fit: BoxFit.fitHeight,
                    )),
                radius: 70,
              ),
            ),
            Text(
              'Diaa Alterh',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Flutter Developer',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
                onTap: () {
                  _launchURL(
                      'https://www.linkedin.com/in/diaa-alterh-a236621a0/');
                },
                child: Image.asset(
                  'images/LinkedIn.png',
                  width: 200,
                )),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
                onTap: () {
                  _launchURL('https://www.facebook.com/diaa.alterh');
                },
                child: Image.asset(
                  'images/facebook.png',
                  width: 200,
                )),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
                onTap: () {
                  _launchURL('https://wa.me/<+963991967155>');
                },
                child: Image.asset(
                  'images/WhatsApp.png',
                  height: 100,
                )),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}
