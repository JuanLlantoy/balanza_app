allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// FORZAR LA VERSIÓN DE ANDROIDX CORE EN TODOS LOS SUBPROYECTOS Y PLUGINS
subprojects {
    project.configurations.all {
        resolutionStrategy {
            force("androidx.core:core:1.13.1")
            force("androidx.core:core-ktx:1.13.1")
        }
    }
}

subprojects {
    plugins.whenPluginAdded {
        if (this is com.android.build.gradle.api.AndroidBasePlugin) {
            project.extensions.getByType(com.android.build.gradle.BaseExtension::class.java).apply {
                compileSdkVersion(34)
            }
        }
    }
}