import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/theme_context.dart';

/// Circular avatar: the person's photo when available, otherwise initials.
class AppAvatar extends StatelessWidget {
  const AppAvatar({required this.name, this.imageUrl, this.size = 40, super.key});

  final String name;
  final Uri? imageUrl;
  final double size;

  /// Up to two initials from the first and last words of [name].
  static String initialsOf(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '';
    final first = words.first.characters.first;
    final last = words.length > 1 ? words.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = this.imageUrl;
    final initials = Center(
      child: Text(
        initialsOf(name),
        style: context.textStyles.titleMedium?.copyWith(
          color: context.appColors.onBrandTint,
          fontSize: size * 0.4,
          height: 1,
        ),
      ),
    );

    return Semantics(
      label: name,
      image: true,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.appColors.brandTint,
            borderRadius: AppRadius.pillAll,
          ),
          child: SizedBox.square(
            dimension: size,
            child: imageUrl == null
                ? initials
                : ClipOval(
                    child: Image.network(
                      imageUrl.toString(),
                      fit: BoxFit.cover,
                      cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
                      errorBuilder: (_, _, _) => initials,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
