import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  String get bannerAdUnit => 'ca-app-pub-7255088691557445/5801027029';

  BannerAdListener get adListener=>_adListener;
  BannerAdListener _adListener=BannerAdListener();
}
