import 'package:cinephilia/utils/helper.dart';
import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
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
                    'is an online media file search engine and browser! mainly for movies And TV Shows downloading & Streaming it acts as a client-side web crawler to crawl and scrape hyperlinks that already available on the internet using public api such as yts for movies information and torrent download links and the tmdb api for TV shows information and for streaming we use links already on the internet such ad video database, google video and video src so  we do respect copyrighted content and we do not store any of the copyrighted content on our servers',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Text(
                    'Warning: downloading or watching torrent Movies & TV Shows is illegal and we do not support it and this app is directed to countries that does not have online payment to get an account for legal app like Netflix, Amazon Prime and Apple tv such as Syria ,we recommend that anyone has access to legal website not to use this app',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
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
