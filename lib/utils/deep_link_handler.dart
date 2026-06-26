import 'package:uni_links/uni_links.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DeepLinkHandler {
  static Future<void> init() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }
    } catch (e) {
      print('Deep link初始化失败: $e');
    }

    linkStream.listen((String? link) {
      if (link != null) {
        _handleDeepLink(link);
      }
    }, onError: (err) {
      print('Deep link监听错误: $err');
    });
  }

  static void _handleDeepLink(String link) {
    try {
      final uri = Uri.parse(link);
      print('收到Deep Link: $link');

      if (uri.scheme != 'kazumi') return;

      switch (uri.host) {
        case 'search':
          final keyword = uri.queryParameters['keyword'];
          if (keyword != null && keyword.isNotEmpty) {
            final encodedKeyword = Uri.encodeComponent(keyword);
            Modular.to.navigate('/search/$encodedKeyword');
          }
          break;

        case 'home':
          Modular.to.navigate('/tab');
          break;

        default:
          Modular.to.navigate('/tab');
      }
    } catch (e) {
      print('处理deep link失败: $e');
    }
  }
}
