// Root build.gradle.kts (project-level)

buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

/**
 * 🔹 Custom build directory (optional – keep if already used)
 */
val newBuildDir: Directory =
    rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

/**
 * 🔥 Firebase / Google Services plugin
 * (IMPORTANT: apply false at root level)
 */
plugins {
    id("com.google.gms.google-services") version "4.4.2" apply false
}
