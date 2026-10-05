import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/core/network/api_values.dart';
import 'package:school_erp/features/notices/domain/entities/notice.dart';

/// Maps a `StudentApi/NoticeBoard` row to [Notice].
abstract final class NoticeMapper {
  /// Returns `null` for rows that must not be shown: unpublished, deleted,
  /// or missing an ID, title or date.
  static Notice? fromJson(Json json, {required Uri? Function(String? path) fileUrl}) {
    if (json['IsPublish'] == false || json['IsDelete'] == true) return null;
    final id = ApiValues.text(json['ID']);
    final title = ApiValues.text(json['NoticeTitle']);
    final postedOn = ApiValues.date(json['NoticeDate']) ?? ApiValues.date(json['EntryDate']);
    if (id == null || title == null || postedOn == null) return null;
    return Notice(
      id: id,
      title: title,
      // Keep the author's line breaks; only trim the ends.
      body: '${json['NoticeDesc'] ?? ''}'.trim(),
      postedOn: postedOn,
      isHoliday: json['IsHoliday'] == true,
      attachmentUrl: _link(json['NoticeDocPath'], fileUrl),
      videoUrl: _link(json['VideoURL'], fileUrl),
      coverImageUrl: _link(json['CoverImagePath'], fileUrl),
    );
  }

  /// Full web links are used as they are; other paths are files on our server.
  static Uri? _link(Object? value, Uri? Function(String? path) fileUrl) {
    final text = ApiValues.text(value);
    if (text == null) return null;
    final uri = Uri.tryParse(text);
    if (uri != null && (uri.scheme == 'https' || uri.scheme == 'http')) return uri;
    return fileUrl(text);
  }
}
