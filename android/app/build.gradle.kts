import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing credentials live in android/key.properties, which is git-ignored.
// When the file is absent (CI, fresh clone) the release build falls back to the
// debug signing config so `flutter build` still works for local verification.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseSigning = keystorePropertiesFile.exists()
if (hasReleaseSigning) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.exstreak.app"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        // Must match the JVM target Flutter's built-in Kotlin compiles to,
        // otherwise Gradle fails with "Inconsistent JVM-target compatibility".
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    defaultConfig {
        applicationId = "com.exstreak.app"
        // Flutter's floor (24) already satisfies the API 23+ that
        // flutter_local_notifications and drift require.
        minSdk = flutter.minSdkVersion
        // Google Play requires new apps to target API 36 from 2026-08-31.
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                // Resolved against android/, where key.properties lives —
                // file() alone would look inside android/app/.
                storeFile = keystoreProperties["storeFile"]?.let {
                    rootProject.file(it)
                }
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Required by flutter_local_notifications for java.time APIs on older devices.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
