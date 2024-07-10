part of craft_dynamic;

class BioMetricUtil {
  static final _sharedPref = CommonSharedPref();

  static Future<bool> biometricAuthenticate() async {
    await _sharedPref.getBio();
    await _sharedPref.setIsListeningToFocusState(false);
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate using biometrics',
        authMessages: <AuthMessages>[
          AndroidAuthMessages(
              signInTitle: 'Login',
              biometricHint: "Login to your ${APIService.appLabel} account"),
          const IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ],
        options:
            const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
      AppLogger.appLogD(
          tag: "biometric authentication results", message: didAuthenticate);
      return didAuthenticate;
    } on PlatformException catch (e) {
      AppLogger.appLogE(tag: "BIOMETRIC ERROR", message: e.toString());

      if (e.code == auth_error.notEnrolled) {
        CommonUtils.showToast("Biometrics not supported by device");
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        CommonUtils.showToast("Try fingerprint again after some time");
      }
    }
    return false;
  }
}
