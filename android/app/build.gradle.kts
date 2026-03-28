plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // 🔥 ADD THIS
    kotlin("android")
}
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.recoverai.recover_ai"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.recoverai.recover_ai"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }
}
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
    implementation("com.google.firebase:firebase-firestore-ktx")
}
