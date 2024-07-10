part of craft_dynamic;

class StringUtil {
  static String formatNumberWithThousandsSeparator(String numberString) {
    // Use RegExp to match digits and add a thousands separator
    String formattedNumber = numberString.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match.group(1)},',
    );
    return formattedNumber;
  }
}
