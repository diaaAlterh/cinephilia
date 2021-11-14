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
      body: Container(
        margin: EdgeInsets.only(top: 30),
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Cinephilia 1.0.0',
                  style: TextStyle(fontSize: 25),
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 20),
                    child: Text(
                      'a torrent movies app that uses the yts api all the movies are free to download and without any ads or disturbing',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    )),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Warning: downloading torrent movies is illegal in most countries of the world so the app creator is not responsible for anything happen',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 20),
                    child: Text(
                      'torrenting is safe in these countries:\nSyria , Egypt , Spain , Netherlands , Switzerland and Mexico\n\nif you are not in any of the countries above do not download anything unless you have a trusted VPN',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    )),
                Text(
                  'To download movies using our app\nyou need to install torrent host like:',
                  style: TextStyle(fontSize: 20),
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
                GestureDetector(
                  onTap: () {
                    helper.launchURL(
                        'https://play.google.com/store/apps/details?id=com.bittorrent.client&hl=en&gl=US');
                  },
                  child: Image.asset(
                    'images/bittorrent.png',
                    height: 100,
                    width: 200,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    helper.launchURL(
                        'https://play.google.com/store/apps/details?id=com.dv.adm&hl=en_US&gl=US');
                  },
                  child: Image.asset(
                    'images/adm.png',
                    height: 100,
                    width: 200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
