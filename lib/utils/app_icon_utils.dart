import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class IconScraper {
  static googlePlayUrl(String packageIdentifier) {
    return "https://play.google.com/store/apps/details?id=$packageIdentifier";
  }

  static getIconUrl(String packageIdentifier) async {
    print(packageIdentifier);
    final url = Uri.parse(googlePlayUrl(packageIdentifier));
    final iconRegex = RegExp(r'https://play-lh.googleusercontent.com[^ ]* ');

    final response = await http.get(url);
    final document = parser.parse(response.body);

    final res = iconRegex.firstMatch(document.body?.innerHtml ?? '');

    if (res == null) {
      print(null);
      return;
    }

    print(res[0]);
  }
}
