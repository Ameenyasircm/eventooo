plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")

    // 🔥 MUST BE LAST
    id("com.google.gms.google-services")
}

android {
    namespace = "com.evento.evento"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.evento.evento"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    /**
     * 🔹 FLAVORS (boys & manager)
     */
    flavorDimensions += "role"

    productFlavors {
        create("boys") {
            dimension = "role"
            applicationId = "com.evento.boys"
        }

        create("manager") {
            dimension = "role"
            applicationId = "com.evento.manager"
        }
    }


    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 🔥 Firebase BOM (recommended)
    implementation(platform("com.google.firebase:firebase-bom:33.5.1"))

    // Add only what you use
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-messaging")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")

    // Multidex
    implementation("androidx.multidex:multidex:2.0.1")
}
