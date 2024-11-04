import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatelessWidget {
  final BannerAd _bannerAd;

  AdBanner({super.key})
      : _bannerAd = BannerAd(
          adUnitId: 'ca-app-pub-3940256099942544/6300978111',
          request: const AdRequest(),
          size: AdSize.largeBanner,
          listener: BannerAdListener(
            onAdLoaded: (ad) => debugPrint('Ad loaded: $ad'),
            onAdFailedToLoad: (ad, error) {
              debugPrint('Failed to load ad: $error');
              ad.dispose();
            },
          ),
        )..load();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd),
    );
  }
}
