// import 'package:awesome_extensions/awesome_extensions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:scrcpygui/providers/settings_provider.dart';

// class ThemeUtils {
//   static ThemeData themeData(WidgetRef ref) {
//     final looks = ref.watch(settingsProvider.select((s) => s.looks));
//     final isDark = looks.brightness == Brightness.dark;

//     return ThemeData(
//       fontFamily: GoogleFonts.notoSans().fontFamily,
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: looks.color,
//         brightness: looks.brightness,
//         surface: isDark
//             ? looks.color.darken(looks.tintLevel.surfaceTintLevel)
//             : looks.color.lighten(looks.tintLevel.surfaceTintLevel),
//         primaryContainer: isDark
//             ? looks.color.darken(looks.tintLevel.primaryTintLevel)
//             : looks.color.lighten(looks.tintLevel.primaryTintLevel),
//         secondaryContainer: isDark
//             ? looks.color.darken(looks.tintLevel.secondaryTintLevel)
//             : looks.color.lighten(looks.tintLevel.secondaryTintLevel),
//       ),
//       useMaterial3: true,
//     );
//   }
// }
