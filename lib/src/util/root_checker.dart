import 'dart:io';

class RootChecker {
  static Future<bool> isDeviceRooted() async {
    return await checkRootMethod1() ||
        await checkRootMethod2() ||
        await checkRootMethod3();
  }

  static Future<bool> checkRootMethod1() async {
    String? buildTags = await getBuildTags();
    return buildTags != null && buildTags.contains("test-keys");
  }

  static Future<bool> checkRootMethod2() async {
    List<String> paths = [
      "/system/app/Superuser.apk",
      "/sbin/su",
      "/system/bin/su",
      "/system/xbin/su",
      "/data/local/xbin/su",
      "/data/local/bin/su",
      "/system/sd/xbin/su",
      "/system/bin/failsafe/su",
      "/data/local/su",
    ];

    for (String path in paths) {
      if (await fileExists(path)) return true;
    }

    return false;
  }

  static Future<bool> checkRootMethod3() async {
    return await fileExists("/system/app/Superuser.apk");
  }

  static Future<String?> getBuildTags() async {
    try {
      final result = await Process.run('getprop', ['ro.build.tags']);
      return result.stdout.toString().trim();
    } catch (e) {
      return null;
    }
  }

  static Future<bool> fileExists(String path) async {
    try {
      File file = File(path);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}
