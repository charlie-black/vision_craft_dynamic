part of craft_dynamic;

class AppLogger {
  static var logger = Logger();
  static var webLog = weblogger.Logger("AppLogger");

  static appLogD({required tag, required message}) {
    if (kDebugMode) {
      kIsWeb ? debugPrint("$tag: $message") : logger.d("$tag: $message");
    }
  }

  static appLogI({required tag, required message}) {
    if (kDebugMode) {
      kIsWeb ? debugPrint("$tag: $message") : logger.i("$tag: $message");
    }
  }

  static appLogE({required tag, required message}) {
    if (kDebugMode) {
      kIsWeb ? debugPrint("$tag: $message") : logger.e("$tag: $message");
    }
  }

  static writeResponseToFile({required fileName, required response}) {
    if (kDebugMode && !kIsWeb) {
      FileOperations().writeFile(fileName, response);
    }
  }
}

class WebLogger {
  final log = weblogger.Logger;
}

class FileOperations {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> getLocalFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName.txt');
  }

  writeFile(String fileName, String response) async {
    final file = getLocalFile(fileName);
    file.then((file) => {
          AppLogger.appLogE(tag: "App Logger", message: "File is writing"),
          file.writeAsString(response)
        });
  }
}
