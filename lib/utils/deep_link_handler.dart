import 'package:app_links/app_links.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DeepLinkHandler {
  static Future<void> init() async {
    final appLinks = AppLinks();

    try {
      // getInitialLink() 返回 Uri?，不是 String
      final initialLink = await appLinks.getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink.toString());
      }
    } catch (e) {
      print('Deep link初始化失败: $e');
    }

    // 用 uriLinkStream 监听 Uri
    appLinks.uriLinkStream.listen((Uri uri) {
      _handleDeepLink(uri.toString());
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
