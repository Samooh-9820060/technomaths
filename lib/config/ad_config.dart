enum AdType {
  interstitial,
  rewarded,
  // Add more ad types if needed
}

enum AppPlatform {
  android,
  ios,
  testAndroid,
  testIos
  // Add more platforms if needed
}

const Map<AdType, Map<AppPlatform, String>> adUnitIds = {
  AdType.interstitial: {
    AppPlatform.android: 'ca-app-pub-6109906096472807/4941429048',
    AppPlatform.ios: 'ca-app-pub-6109906096472807/4941429048',
    AppPlatform.testAndroid: 'ca-app-pub-3940256099942544/1033173712',
    AppPlatform.testIos: 'ca-app-pub-3940256099942544/4411468910',
  },
  AdType.rewarded: {
    AppPlatform.android: 'ca-app-pub-6109906096472807/2881924681',
    AppPlatform.ios: 'ca-app-pub-6109906096472807/2881924681',
    AppPlatform.testAndroid: 'ca-app-pub-3940256099942544/5224354917',
    AppPlatform.testIos: 'ca-app-pub-3940256099942544/1712485313',
  },
};
