import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData cleanTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF10B981),
      secondary: Color(0xFF34D399),
      surface: Color(0xFFF3F4F6),
      error: Color(0xFFDC2626),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Color(0xFF111827),
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: const Color(0xFFFFFFFF),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF111827),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFF111827),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Cards
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
      ),
      labelStyle: const TextStyle(
        color: Color(0xFF6B7280),
      ),
      prefixIconColor: Color(0xFF6B7280),
      suffixIconColor: Color(0xFF6B7280),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF10B981),
          width: 1.5,
        ),
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(
        const Color(0xFF10B981),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    dividerColor: const Color(0xFFE5E7EB),

    iconTheme: const IconThemeData(
      color: Color(0xFF6B7280),
    ),
  );
}


// //gold
// class AppTheme {
//   static ThemeData luxuryLightTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.light,

//     colorScheme: const ColorScheme.light(
//       primary: Color(0xFFD4AF37),
//       secondary: Color(0xFFF5E7A1),
//       surface: Color(0xFFFFFFFF),
//       error: Color(0xFFDC2626),
//       onPrimary: Colors.black,
//       onSecondary: Colors.black,
//       onSurface: Color(0xFF111111),
//       onError: Colors.white,
//     ),

//     scaffoldBackgroundColor: const Color(0xFFF8F8F8),

//     // AppBar
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.white,
//       foregroundColor: Color(0xFF111111),
//       elevation: 0,
//       centerTitle: true,
//       titleTextStyle: TextStyle(
//         color: Color(0xFF111111),
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//       ),
//     ),

//     // Cards
//     cardTheme: CardTheme(
//       color: Colors.white,
//       elevation: 4,
//       shadowColor: Colors.black12,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//       ),
//     ),

//     // Input Fields
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: const Color(0xFFF1F1F1),
//       hintStyle: const TextStyle(
//         color: Color(0xFF9E9E9E),
//       ),
//       labelStyle: const TextStyle(
//         color: Color(0xFF555555),
//       ),
//       prefixIconColor: Color(0xFF555555),
//       suffixIconColor: Color(0xFF555555),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(
//           color: Color(0xFFD4AF37),
//           width: 1.5,
//         ),
//       ),
//     ),

//     // Buttons
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFFD4AF37),
//         foregroundColor: Colors.black,
//         elevation: 0,
//         padding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 16,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//       ),
//     ),

//     // Checkbox
//     checkboxTheme: CheckboxThemeData(
//       fillColor: WidgetStateProperty.all(
//         const Color(0xFFD4AF37),
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(4),
//       ),
//     ),

//     dividerColor: const Color(0xFFE5E5E5),

//     iconTheme: const IconThemeData(
//       color: Color(0xFF555555),
//     ),
//   );
// }


// //green
// class AppTheme {
//   static ThemeData cleanTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.light,

//     colorScheme: const ColorScheme.light(
//       primary: Color(0xFF10B981),
//       secondary: Color(0xFF34D399),
//       surface: Color(0xFFF3F4F6),
//       error: Color(0xFFDC2626),
//       onPrimary: Colors.white,
//       onSecondary: Colors.black,
//       onSurface: Color(0xFF111827),
//       onError: Colors.white,
//     ),


//     scaffoldBackgroundColor: const Color(0xFFFFFFFF),

//     // AppBar
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.white,
//       foregroundColor: Color(0xFF111827),
//       elevation: 0,
//       centerTitle: true,
//       titleTextStyle: TextStyle(
//         color: Color(0xFF111827),
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//       ),
//     ),

//     // Cards
//     cardTheme: CardTheme(
//       color: Colors.white,
//       elevation: 3,
//       shadowColor: Colors.black12,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//       ),
//     ),

//     // Input Fields
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: const Color(0xFFF3F4F6),


//       hintStyle: const TextStyle(
//         color: Color(0xFF9CA3AF),
//       ),

//       labelStyle: const TextStyle(
//         color: Color(0xFF6B7280),
//       ),

//       prefixIconColor: Color(0xFF6B7280),
//       suffixIconColor: Color(0xFF6B7280),

//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),

//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),

//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(
//           color: Color(0xFF10B981),
//           width: 1.5,
//         ),
//       ),
//     ),


//     // Buttons
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF10B981),
//         foregroundColor: Colors.white,
//         elevation: 0,

//         padding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 16,
//         ),

//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//       ),
//     ),

//     // Checkbox
//     checkboxTheme: CheckboxThemeData(
//       fillColor: WidgetStateProperty.all(
//         const Color(0xFF10B981),
//       ),

//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(4),
//       ),
//     ),

//     dividerColor: const Color(0xFFE5E7EB),

//     iconTheme: const IconThemeData(
//       color: Color(0xFF6B7280),
//     ),
//   );
// }


//ذهبي
// class AppTheme {
//   static ThemeData luxuryTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.dark,

//     colorScheme: const ColorScheme.dark(
//       primary: Color(0xFFD4AF37),
//       secondary: Color(0xFF2A2A2A),
//       surface: Color(0xFF1A1A1A),
//       error: Color(0xFFCF6679),
//       onPrimary: Colors.black,
//       onSecondary: Colors.white,
//       onSurface: Colors.white,
//       onError: Colors.black,
//     ),

//     scaffoldBackgroundColor: const Color(0xFF0F0F0F),

//     // AppBar
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color(0xFF1A1A1A),
//       foregroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: true,
//       titleTextStyle: TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//         fontWeight: FontWeight.w600,

//       ),
//     ),

//     // Cards
//     cardTheme: CardTheme(
//       color: const Color(0xFF1A1A1A),
//       elevation: 8,
//       shadowColor: Colors.black54,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//       ),
//     ),

//     // Input Fields
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: const Color(0xFF222222),

//       hintStyle: const TextStyle(
//         color: Color(0xFFB0B0B0),
//       ),

//       labelStyle: const TextStyle(
//         color: Colors.white70,
//       ),

//       prefixIconColor: Colors.white70,
//       suffixIconColor: Colors.white70,

//       border: OutlineInputBorder(

//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),

//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),

//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(
//           color: Color(0xFFD4AF37),
//           width: 1.5,
//         ),
//       ),
//     ),

//     // Buttons
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFFD4AF37),
//         foregroundColor: Colors.black,
//         elevation: 0,

//         padding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 16,
//         ),

//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//       ),
//     ),

//     // Checkbox
//     checkboxTheme: CheckboxThemeData(
//       fillColor: WidgetStateProperty.all(
//         const Color(0xFFD4AF37),
//       ),

//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(4),
//       ),
//     ),

//     dividerColor: Colors.white10,

//     iconTheme: const IconThemeData(
//       color: Colors.white70,
//     ),
//   );
// }


// class AppTheme {
//   static ThemeData darkTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.dark,

//     colorScheme: const ColorScheme.dark(
//       primary: Color(0xFF6750A4),
//       secondary: Color(0xFF03DAC6),
//       surface: Color(0xFF1E1E1E),
//       error: Color(0xFFCF6679),
//       onPrimary: Colors.white,
//       onSecondary: Colors.black,
//       onSurface: Colors.white,
//       onError: Colors.black,
//     ),

//     scaffoldBackgroundColor: const Color(0xFF121212),

//     // AppBar
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color(0xFF1E1E1E),
//       foregroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: true,
//       titleTextStyle: TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//       ),
//     ),

//     // Cards
//     cardTheme: CardTheme(
//       color: const Color(0xFF242424),
//       elevation: 8,
//       shadowColor: Colors.black54,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//       ),
//     ),

//     // Input Fields
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: const Color(0xFF2A2A2A),
//       hintStyle: const TextStyle(
//         color: Color(0xFFB0B0B0),
//       ),
//       labelStyle: const TextStyle(
//         color: Colors.white70,
//       ),
//       prefixIconColor: Colors.white70,
//       suffixIconColor: Colors.white70,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(
//           color: Color(0xFF6750A4),
//           width: 1.5,
//         ),
//       ),
//     ),

//     // Buttons
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF6750A4),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         padding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 16,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//       ),
//     ),

//     // Checkbox
//     checkboxTheme: CheckboxThemeData(
//       fillColor: WidgetStateProperty.all(
//         const Color(0xFF6750A4),
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(4),
//       ),
//     ),

//     // Divider
//     dividerColor: Colors.white10,

//     // Icon
//     iconTheme: const IconThemeData(
//       color: Colors.white70,
//     ),
//   );
// }
