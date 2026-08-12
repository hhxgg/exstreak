# Flutter / Dart
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# flutter_local_notifications keeps notification payload models via reflection
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**

# Play Core is referenced by the Flutter engine's deferred components support,
# which this app does not use.
-dontwarn com.google.android.play.core.**

# Keep annotations used by generated code
-keepattributes *Annotation*, InnerClasses, Signature, EnclosingMethod
