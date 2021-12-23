import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsHandler {
  InterstitialAd? _interstitialAd;

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/8691691433',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
          },
        ));
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void CreateBannerAd(List list){
    for (int i = list.length - 2; i >= 1; i -= 2) {
      list.insert(
          i,
          BannerAd(
              size: AdSize.banner,
              adUnitId: 'ca-app-pub-3940256099942544/6300978111',
              listener: BannerAdListener(),
              request: AdRequest())
            ..load());
    }
  }
}

AdsHandler adsHandler = AdsHandler();
