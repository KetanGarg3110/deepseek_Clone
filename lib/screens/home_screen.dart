import 'package:deepseek/ad_helper/ad_helper.dart';
import 'package:deepseek/models/home_type.dart';
import 'package:deepseek/provider/theme_provider.dart';
import 'package:deepseek/screens/ImageHistory.dart';
import 'package:deepseek/screens/chat_history.dart';
import 'package:deepseek/widgets/home_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      /// this is for Banner
      BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            // when the ad is loaded successfully
            setState(() {
              _bannerAd = ad as BannerAd;
            });
          },
          onAdFailedToLoad: (ad, error) {
            print('Failed to load a banner ad: ${error.message}');
            ad.dispose();
          },
        ),
        request: AdRequest(),
      ).load();

      _loadInterstitialAd(); // Initialize here
      // /// this is for Interstitial Ad
      // InterstitialAd.load(
      //   adUnitId: AdHelper.interstitialAdUnitId,
      //   request: AdRequest(),
      //   adLoadCallback: InterstitialAdLoadCallback(
      //     onAdLoaded: (ad) {
      //       _interstitialAd = ad;
      //       ad.fullScreenContentCallback = FullScreenContentCallback(
      //         onAdDismissedFullScreenContent: (ad) {
      //           ad.dispose();
      //           _interstitialAd = null;
      //           _loadInterstitialAd(); // Reload
      //         },
      //         onAdFailedToShowFullScreenContent: (ad, error) {
      //           ad.dispose();
      //           _interstitialAd = null;
      //         },
      //       );
      //     },
      //     onAdFailedToLoad: (error) {
      //       print('Failed to load interstitial ad: $error');
      //     },
      //   ),
      // );
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd(); // Reload
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Failed to load interstitial ad: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  //   @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Assistant",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return IconButton(
                padding: const EdgeInsets.only(right: 10),
                onPressed: () {
                  provider.toggleTheme();
                },
                icon: Icon(
                  Icons.brightness_4_rounded,
                  size: 26,
                  color: Colors.blue,
                ),
              );
            },
          ),
        ],
        centerTitle: true,
        elevation: 5,
        bottomOpacity: 4,
        shadowColor: Colors.black,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Texts History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatHistory()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Images History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageHistory()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Videos History'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),

        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.symmetric(vertical: 5),
              children:
                  HomeType.values.map((e) => HomeCard(homeType: e)).toList(),
            ),
            if (_bannerAd != null && !kIsWeb)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0, right: 10.0),
        child: FloatingActionButton(
          onPressed: () {
            if (_interstitialAd != null) {
              _interstitialAd?.show();
            } else {
              print('Interstitial ad is not ready yet,');
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
