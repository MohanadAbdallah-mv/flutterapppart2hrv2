plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ascon.flutterapppart2hr"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.ascon.flutterapppart2hr"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    signingConfigs {
        create("release") { // Use create for clarity and ensure it's defined
            keyAlias = "myFirstKeyStore"
            keyPassword = "Moh@2025"
            storeFile = file("C:/Users/pc/myFirstKeyStore.jks")
            storePassword = "Moh@2025"
        }}
    buildTypes {
        getByName("release") { // Correct way to configure the existing release build type
            // TODO: Add your own signing config for the release build.
            signingConfig = signingConfigs.getByName("release")

        }
    }
}

flutter {
    source = "../.."
}