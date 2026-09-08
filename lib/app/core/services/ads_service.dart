import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  // ------------------ Singleton ------------------
  AdsService._private();
  static final AdsService instance = AdsService._private();

  // ------------------ Ad IDs Android------------------
  final String appOpenId = kDebugMode
      ? "ca-app-pub-3940256099942544/9257395921"
      : 'ca-app-pub-3681204410277830/1719348686';
  final String bannerId = kDebugMode
      ? "ca-app-pub-3940256099942544/6300978111"
      : 'ca-app-pub-3681204410277830/9952072249';
  final String interstitialId = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'
      : "ca-app-pub-3681204410277830/9406267012";

  //Test Ids
  final String rewardedId = "ca-app-pub-3940256099942544/5224354917";
  final String rewardedInterstitialId =
      'ca-app-pub-3940256099942544/5354046379';
  final String nativeId = 'ca-app-pub-3940256099942544/2247696110';

  // ------------------ Ads ------------------
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  AppOpenAd? _appOpenAd;

  final List<NativeAd> _nativeAds = [];
  final ValueNotifier<bool> bannerLoaded = ValueNotifier(false);
  bool _isShowingAd = false;
  bool _isRewardedLoading = false;
  BannerAd? get bannerAd => _bannerAd;

  // ------------------ Frequency Control ------------------
  int _clickCount = 0;
  final int interstitialFrequency = 3;

  // ------------------ Init ------------------
  void init({bool enableNative = false}) async {
    await MobileAds.instance.initialize();

    loadAppOpenAd();
    loadBannerAd();
    loadInterstitialAd();
    loadRewardedAd();
    loadRewardedInterstitialAd();

    if (enableNative) {
      loadMultipleNativeAds(3);
    }
  }

  bool get isBannerReady => _bannerAd != null && bannerLoaded.value;
  Future<bool> waitForBannerAd({int timeoutSeconds = 5}) async {
    int retry = 0;

    while (!isBannerReady && retry < timeoutSeconds) {
      retry++;

      if (_bannerAd == null) {
        loadBannerAd();
      }

      await Future.delayed(const Duration(seconds: 1));
    }

    return isBannerReady;
  }

  // ================== BANNER ==================
  Future<void> loadBannerAd() async {
    if (_bannerAd != null) return;

    bannerLoaded.value = false;

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
        },
      ),
    );

    await _bannerAd!.load();
  }

  Widget bannerWidget() {
    if (_bannerAd == null) return const SizedBox();

    return SizedBox(
      height: _bannerAd!.size.height.toDouble(),
      width: _bannerAd!.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  // ================== INTERSTITIAL ==================
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          log("✅ Interstitial Loaded");
        },
        onAdFailedToLoad: (error) {
          log("❌ Interstitial Failed: $error");
          _interstitialAd = null;

          Future.delayed(const Duration(seconds: 5), loadInterstitialAd);
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd == null || _isShowingAd) return;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => _isShowingAd = true,
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
      },
    );

    _interstitialAd!.show();
  }

  void showInterstitialWithControl() {
    _clickCount++;

    if (_clickCount % interstitialFrequency == 0) {
      showInterstitialAd();
    }
  }

  void handleToolClick(VoidCallback navigation) {
    _clickCount++;

    if (_clickCount % 3 == 0) {
      if (_interstitialAd != null) {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _interstitialAd = null;
            loadInterstitialAd();

            navigation();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _interstitialAd = null;
            loadInterstitialAd();

            navigation();
          },
        );

        _interstitialAd!.show();
      } else {
        navigation();
        loadInterstitialAd();
      }
    } else {
      navigation();
    }
  }

  // ================== REWARDED ==================
  void loadRewardedAd() {
    if (_isRewardedLoading) return;

    _isRewardedLoading = true;

    log("🚀 loadRewardedAd called");

    RewardedAd.load(
      adUnitId: rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
          log("✅ Rewarded Loaded");
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isRewardedLoading = false;

          log("❌ Rewarded Failed: $error");

          Future.delayed(const Duration(seconds: 5), () {
            log("🔄 Retrying Rewarded Ad...");
            loadRewardedAd();
          });
        },
      ),
    );
  }

  void showRewardedAd(VoidCallback onReward) async {
    if (_rewardedAd == null) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      loadRewardedAd();

      int waited = 0;

      while (_rewardedAd == null && waited < 10) {
        await Future.delayed(const Duration(seconds: 1));
        waited++;
      }

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (_rewardedAd == null) {
        onReward();
        return;
      }
    }

    if (_isShowingAd) return;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;

        Get.snackbar("Ad Error", error.message);

        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onReward();
      },
    );
  }

  // ================== REWARDED INTERSTITIAL ==================
  void loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: rewardedInterstitialId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialAd = ad;
          log("✅ Rewarded Interstitial Loaded");
        },
        onAdFailedToLoad: (error) {
          log("❌ Rewarded Interstitial Failed: $error");
          _rewardedInterstitialAd = null;

          Future.delayed(
            const Duration(seconds: 5),
            loadRewardedInterstitialAd,
          );
        },
      ),
    );
  }

  void showRewardedInterstitialAd(VoidCallback onReward) {
    if (_rewardedInterstitialAd == null || _isShowingAd) return;

    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdShowedFullScreenContent: (ad) => _isShowingAd = true,
          onAdDismissedFullScreenContent: (ad) {
            _isShowingAd = false;
            ad.dispose();
            _rewardedInterstitialAd = null;
            loadRewardedInterstitialAd();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            _isShowingAd = false;
            ad.dispose();
            _rewardedInterstitialAd = null;
            loadRewardedInterstitialAd();
          },
        );

    _rewardedInterstitialAd!.show(
      onUserEarnedReward: (ad, reward) => onReward(),
    );
  }

  // ================== APP OPEN ==================

  Completer<bool>? _appOpenCompleter;

  Future<bool> waitForAppOpenAd() async {
    if (_appOpenAd != null) {
      return true;
    }

    _appOpenCompleter ??= Completer<bool>();
    return _appOpenCompleter!.future;
  }

  void loadAppOpenAd() {
    log("🚀 [AppOpen] Start loading...");

    AppOpenAd.load(
      adUnitId: appOpenId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          log("✅ [AppOpen] Loaded successfully");

          _appOpenAd = ad;

          if (_appOpenCompleter != null && !_appOpenCompleter!.isCompleted) {
            _appOpenCompleter!.complete(true);
          }

          _appOpenCompleter = null;
        },

        onAdFailedToLoad: (error) {
          log("❌ [AppOpen] Failed: $error");

          _appOpenAd = null;

          if (_appOpenCompleter != null && !_appOpenCompleter!.isCompleted) {
            _appOpenCompleter!.complete(false);
          }

          _appOpenCompleter = null;

          Future.delayed(const Duration(seconds: 5), loadAppOpenAd);
        },
      ),
    );
  }

  bool get isAppOpenAdReady => _appOpenAd != null;

  void showAppOpenAd({VoidCallback? onComplete}) {
    if (_appOpenAd == null || _isShowingAd) {
      onComplete?.call();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },

      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;

        ad.dispose();
        _appOpenAd = null;

        loadAppOpenAd();

        onComplete?.call(); // Navigate after close
      },

      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;

        ad.dispose();
        _appOpenAd = null;

        loadAppOpenAd();

        onComplete?.call(); // Navigate if failed
      },
    );

    _appOpenAd!.show();
  }

  // ================== NATIVE ==================
  void loadMultipleNativeAds(int count) {
    for (int i = 0; i < count; i++) {
      NativeAd(
        adUnitId: nativeId,
        factoryId: "listTile",
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            _nativeAds.add(ad as NativeAd); // ✅ use callback ad
            log("✅ Native Loaded (${_nativeAds.length})");
          },
          onAdFailedToLoad: (ad, error) {
            log("❌ Native Failed: $error");
            ad.dispose();
          },
        ),
      ).load();
    }
  }

  Widget nativeAdWidget(int index) {
    if (_nativeAds.isEmpty) return const SizedBox();

    final ad = _nativeAds[index % _nativeAds.length];

    return SizedBox(height: 120, child: AdWidget(ad: ad));
  }

  // ================== DISPOSE ==================
  void disposeAll() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
    _appOpenAd?.dispose();
    _bannerAd?.dispose();
    _bannerAd = null;
    bannerLoaded.value = false;

    for (var ad in _nativeAds) {
      ad.dispose();
    }
    _nativeAds.clear();
  }

  void disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
    bannerLoaded.value = false;
  }
}
