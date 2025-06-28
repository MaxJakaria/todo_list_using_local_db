# 📝 ToDo List Using Isar DB

A new **Flutter project** demonstrating a ToDo List app.

---

## 🚀 Getting Started

This project [initially used a simple `List`](https://github.com/MaxJakaria/todo_list_using_local_db/tree/f9fc0be2c6ce9c55e8166c03e6027fc5cbaebd89) in Dart to store tasks as a temporary in-memory database.

Before integrating **Isar** (a high-performance local NoSQL database), follow the steps below to prepare your project.

---

## 🔧 Android Build Configuration (Required for Isar)

To properly set up Isar and ensure a clean build process, **edit** your `android/build.gradle.kts` file as follows:

```kotlin
import com.android.build.gradle.BaseExtension
import org.gradle.api.Project
import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    afterEvaluate {
        // this: Project
        if (plugins.hasPlugin("com.android.application") || plugins.hasPlugin("com.android.library")) {
            extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                compileSdkVersion(34)
                buildToolsVersion("34.0.0")
            }
        }

        if (extensions.findByName("android") != null) {
            extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                if (namespace == null) {
                    namespace = group.toString()
                }
            }
        }
    }

    val newSubprojectBuildDir = newBuildDir.dir(name)
    layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects { evaluationDependsOn(":app") }

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
```
