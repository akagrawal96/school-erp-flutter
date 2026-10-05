import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens web links (attachments, videos) in the browser or a matching app.
abstract interface class LinkOpener {
  /// Returns `false` when the link is not a web link or nothing can open it.
  Future<bool> open(Uri uri);
}

final class UrlLauncherLinkOpener implements LinkOpener {
  const UrlLauncherLinkOpener();

  @override
  Future<bool> open(Uri uri) async {
    // Links come from server content: only web links are opened, never other
    // schemes such as tel:, file: or intent:.
    if (uri.scheme != 'https' && uri.scheme != 'http') return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      return false;
    }
  }
}

final linkOpenerProvider = Provider<LinkOpener>((ref) => const UrlLauncherLinkOpener());
