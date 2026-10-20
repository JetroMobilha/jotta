class AdConfig {
  /// ATENÇÃO: Defina esta variável como [false] quando for publicar a aplicação na loja!
  /// Enquanto estiver como [true], a app usará anúncios de teste para proteger a sua conta AdMob.
  static const bool useTestAds = true;

  // ===========================================================================
  // 📱 CONFIGURAÇÕES DO GOOGLE ADMOB (ANDROID)
  // ===========================================================================

  /// O seu ID de Aplicação do Google AdMob
  /// Formato típico: ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
  /// (Lembre-se de colar este mesmo ID no ficheiro android/app/src/main/AndroidManifest.xml)
  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713';

  /// O seu ID do Bloco de Anúncios de Banner (Rodapé)
  /// Formato típico: ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
  static const String androidBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  /// O seu ID do Bloco de Anúncios Intersticial (Ecrã Inteiro ao Limpar)
  /// Formato típico: ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
  static const String androidInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  /// O seu ID do Bloco de Anúncios de Vídeo Premiado (Rewarded Ad)
  /// Formato típico: ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
  static const String androidRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
}
