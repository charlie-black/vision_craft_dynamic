part of craft_dynamic;

class CommonUtils {
  static var snackBarDuration = const Duration(seconds: 6);
  static const snackBarBehavior = SnackBarBehavior.fixed;
  static var errorColor = Colors.red;
  static var successColor = Colors.green[600];

  static Future<void> selectDate(BuildContext context,
      {refreshDate, isTodayInitialDate = false}) async {
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: isTodayInitialDate
            ? selectedDate
            : DateTime.now().subtract(const Duration(days: 365 * 2)),
        lastDate: DateTime.now().add(const Duration(days: 365 * 5)));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      refreshDate(true, newText: selectedDate);
    }
  }

  static Future<void> openUrl(Uri url, {context}) async {
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      AppLogger.appLogE(tag: "url launch error", message: e.toString());
      buildErrorSnackBar(context: context, message: "Could not launch url");
      Navigator.pop(context);
    }
  }

  static buildErrorSnackBar({context, message}) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: snackBarDuration,
            content: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(message)
              ],
            ),
            behavior: snackBarBehavior,
            backgroundColor: errorColor),
      );
    } catch (e) {
      AppLogger.appLogE(tag: "snackbar error", message: e.toString());
    }
  }

  static navigateToRoute(
      {required context, required widget, isTransparentScreen = false}) {
    isTransparentScreen
        ? Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false, // Set the route as transparent
              pageBuilder: (context, animation, secondaryAnimation) => widget,
            ),
          )
        : Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => widget),
          );
  }

  static navigateToRouteAndPopAll({required context, required widget}) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => widget), (route) => false);
  }

  static getXRouteAndPopAll({required widget}) {
    Get.offAll(widget);
  }

  static getxPop({required widget}) {
    Get.off(widget);
  }

  static getxNavigate({required widget}) {
    Get.to(widget);
  }

  static showToast(message,
      {backgroundColor = Colors.black87,
      textColor = Colors.white,
      lenth = Toast.LENGTH_SHORT}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0);
  }

  static showActionSnackBar({context, message, action}) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: snackBarDuration,
            content: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.download_done,
                  color: Colors.white,
                ),
                Text(message),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            action: action,
            backgroundColor: Colors.green),
      );
    } catch (e) {
      AppLogger.appLogE(tag: "snackbar error", message: e.toString());
    }
  }

  static Color parseColor(String colorhex) {
    String color = colorhex.replaceAll('#', '');
    try {
      if (color.length == 6) {
        color = "FF$color";
      }
      return Color(int.parse(color, radix: 16));
    } catch (e) {
      AppLogger.appLogE(tag: "error parsing color $color", message: e);
    }
    return Colors.white;
  }

  static Map<String, dynamic> sortDropdown(Map<String, dynamic> list,
      {searchKeywords = "Own Number"}) {
    list.entries.toList().sort((a, b) {
      return a.value.compareTo(b.value);
    });
    list.forEach((key, value) => debugPrint("item sorted $value"));
    return list;
  }

  static vibrate() {
    if (!kIsWeb) {
      Vibration.vibrate();
    }
  }
}
