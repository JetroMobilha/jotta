import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';

class AdService {
  // Retorna o ID de Teste se estiver em Modo de Desenvolvimento/Teste ou o ID Real de Produção
  static String get bannerAdUnitId {
    if (kDebugMode || AdConfig.useTestAds) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111'; // ID de Teste Banner Android
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716'; // ID de Teste Banner iOS
      }
    }
    return AdConfig.androidBannerAdUnitId;
  }

  static String get interstitialAdUnitId {
    if (kDebugMode || AdConfig.useTestAds) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712'; // ID de Teste Intersticial Android
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/4411468910'; // ID de Teste Intersticial iOS
      }
    }
    return AdConfig.androidInterstitialAdUnitId;
  }

  static String get rewardedAdUnitId {
    if (kDebugMode || AdConfig.useTestAds) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/5224354917'; // ID de Teste Rewarded Android
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/1712409664'; // ID de Teste Rewarded iOS
      }
    }
    return AdConfig.androidRewardedAdUnitId;
  }

  static InterstitialAd? _interstitialAd;
  static bool _isLoadingInterstitial = false;

  static RewardedAd? _rewardedAd;
  static bool _isLoadingRewarded = false;

  static void loadInterstitialAd() {
    if (_isLoadingInterstitial || _interstitialAd != null) return;
    _isLoadingInterstitial = true;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoadingInterstitial = false;
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd(); // Preload next
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd(); // Preload next
            },
          );
        },
        onAdFailedToLoad: (err) {
          _isLoadingInterstitial = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  static void loadRewardedAd() {
    if (_isLoadingRewarded || _rewardedAd != null) return;
    _isLoadingRewarded = true;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoadingRewarded = false;
          
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              loadRewardedAd(); // Preload next
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _rewardedAd = null;
              loadRewardedAd(); // Preload next
            },
          );
        },
        onAdFailedToLoad: (err) {
          _isLoadingRewarded = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  static void showRandomAd({VoidCallback? onComplete}) {
    final random = Random();
    final bool showVideo = random.nextBool(); // 50% chance for True/False

    void handleAdDismissed() {
      if (onComplete != null) onComplete();
    }

    if (showVideo) {
      if (_rewardedAd != null) {
        // Intercept close events to trigger complete callback
        _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _rewardedAd = null;
            handleAdDismissed();
            loadRewardedAd();
          },
          onAdFailedToShowFullScreenContent: (ad, err) {
            ad.dispose();
            _rewardedAd = null;
            handleAdDismissed();
            loadRewardedAd();
          },
        );
        _rewardedAd!.show(onUserEarnedReward: (_, __) {});
      } else if (_interstitialAd != null) {
        // Fallback to interstitial
        _showInterstitial(handleAdDismissed);
      } else {
        handleAdDismissed();
        loadRewardedAd();
        loadInterstitialAd();
      }
    } else {
      if (_interstitialAd != null) {
        _showInterstitial(handleAdDismissed);
      } else if (_rewardedAd != null) {
        // Fallback to rewarded
        _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _rewardedAd = null;
            handleAdDismissed();
            loadRewardedAd();
          },
          onAdFailedToShowFullScreenContent: (ad, err) {
            ad.dispose();
            _rewardedAd = null;
            handleAdDismissed();
            loadRewardedAd();
          },
        );
        _rewardedAd!.show(onUserEarnedReward: (_, __) {});
      } else {
        handleAdDismissed();
        loadRewardedAd();
        loadInterstitialAd();
      }
    }
  }

  static void _showInterstitial(VoidCallback onComplete) {
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        onComplete();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _interstitialAd = null;
        onComplete();
        loadInterstitialAd();
      },
    );
    _interstitialAd!.show();
  }
}
