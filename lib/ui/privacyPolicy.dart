import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';

class privacyPolicy extends StatefulWidget {
  @override
  _privacyPolicyState createState() => _privacyPolicyState();
}

class _privacyPolicyState extends State<privacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListTile(
                  title: Text(
                    'Cinephilia v 1.0.0',
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    'is an online app that provide links that already available on the internet to stream movies And TV Shows,\n\nit acts as a client-side with no server to store any kind of data copyrighted or not,\n\nusing public api such as yts for movies information and torrent download links and the tmdb api for TV shows information and for streaming we just provide links that already exist on the internet such ad video database, google video and video src,\n\nso we do respect copyrighted content and we do not store any of the copyrighted content',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Warning :',
                    style: TextStyle(fontSize: 20,color: Theme.of(context).errorColor),
                  ),
                  subtitle: Text(
                    'downloading or watching free Movies & TV Shows is illegal and we do not support it and this app is directed to people who live in countries that does not have online payment to get an account for legal app like Netflix, Amazon Prime and Apple ,we recommend that anyone has access to legal website not to use this app',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Text(
                    'to download movies and tv Show Using our app you need to install a torrent files host such as',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      helper.launchURL(
                          'https://play.google.com/store/apps/details?id=com.utorrent.client&hl=en&gl=US');
                    },
                    child: Image.asset(
                      'images/UTorrent.png',
                      height: 100,
                      width: 200,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
