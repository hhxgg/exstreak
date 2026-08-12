import 'package:flutter/widgets.dart';

/// Spacing scale. Every gap in the app is one of these values.
abstract final class Gap {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double giant = 56;

  /// Horizontal padding used by every full-width screen.
  static const double screenH = 20;
}

/// Corner radii.
abstract final class Radii {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
  static const double pill = 999;

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius sheetRadius = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
  static const BorderRadius pillRadius = BorderRadius.all(
    Radius.circular(pill),
  );
}

/// Sizing constants that recur across screens.
abstract final class Sizes {
  /// Minimum tap target — Material accessibility guidance.
  static const double minTapTarget = 48;
  static const double buttonHeight = 54;
  static const double buttonHeightCompact = 44;
  static const double iconChip = 40;
  static const double bottomNavHeight = 64;

  /// Extra bottom padding so content clears the nav bar when scrolled.
  static const double scrollBottomInset = 96;
}

/// Named animation durations, so motion feels consistent.
abstract final class Motion {
  static const Duration instant = Duration(milliseconds: 120);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 520);
  static const Duration celebrate = Duration(milliseconds: 900);

  static const Curve emphasized = Curves.easeOutCubic;
  static const Curve standard = Curves.easeInOut;
  static const Curve springy = Curves.easeOutBack;
}
