plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.helpampm.mobile"
    compileSdk = 35
    // ndkVersion = flutter.ndkVersion  // Commented out to avoid NDK installation

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true // Required by flutter_local_notifications
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.helpampm.mobile"
        minSdk = 23
        targetSdk = 35
        versionCode = 3
        versionName = "1.0.1"
    }

    buildTypes {
        release {
            // TODO: Add signing configuration for release builds
            // For now, using debug signing
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.20")
    // implementation("com.google.firebase:firebase-analytics-ktx:21.5.0") // Temporarily commented for smaller APK
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") // Required by flutter_local_notifications
}
