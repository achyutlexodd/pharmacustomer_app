# Graphy Codebase Analysis

### File Structure Summary
- Total Files: 194
- Total Directories: 112
- File Extensions: .iml: 2, .lock: 1, .md: 3, .yaml: 3, .xcworkspacedata: 3, .plist: 7, .swift: 15, .entitlements: 2, .png: 35, .json: 11, .xib: 1, .xcconfig: 10, .pbxproj: 2, .xcscheme: 2, .sh: 2, .env: 2, .dart: 12, .html: 1, .xcsettings: 2, .h: 9, .m: 1, .storyboard: 2, .py: 1, .txt: 6, .cc: 4, .cmake: 2, .properties: 3, .kts: 3, .bat: 1, .xml: 7, .java: 1, .kt: 1, .jar: 1, .stamp: 11, .dill: 1, .d: 4, .cpp: 4, .manifest: 1, .rc: 1, .ico: 1

### Directory Tree
```
  ├── pharmacustomer_app.iml
  ├── macos
   │  ├── Runner.xcworkspace
   │  │  ├── contents.xcworkspacedata
   │  │  └── xcshareddata
   │  │    ├── IDEWorkspaceChecks.plist
   │  │    └── swiftpm
   │  │       └── configuration
   │  ├── RunnerTests
   │  │  └── RunnerTests.swift
   │  ├── Runner
   │  │  ├── Assets.xcassets
   │  │  │  └── AppIcon.appiconset
   │  │  │    ├── app_icon_16.png
   │  │  │    ├── app_icon_1024.png
   │  │  │    ├── app_icon_256.png
   │  │  │    ├── app_icon_64.png
   │  │  │    ├── app_icon_512.png
   │  │  │    ├── app_icon_128.png
   │  │  │    ├── Contents.json
   │  │  │    └── app_icon_32.png
   │  │  ├── DebugProfile.entitlements
   │  │  ├── Base.lproj
   │  │  │  └── MainMenu.xib
   │  │  ├── MainFlutterWindow.swift
   │  │  ├── Configs
   │  │  │  ├── AppInfo.xcconfig
   │  │  │  ├── Debug.xcconfig
   │  │  │  ├── Release.xcconfig
   │  │  │  └── Warnings.xcconfig
   │  │  ├── AppDelegate.swift
   │  │  ├── Info.plist
   │  │  └── Release.entitlements
   │  ├── Runner.xcodeproj
   │  │  ├── project.pbxproj
   │  │  ├── project.xcworkspace
   │  │  │  └── xcshareddata
   │  │  │    ├── IDEWorkspaceChecks.plist
   │  │  │    └── swiftpm
   │  │  │       └── configuration
   │  │  └── xcshareddata
   │  │    └── xcschemes
   │  │       └── Runner.xcscheme
   │  ├── Flutter
   │  │  ├── Flutter-Debug.xcconfig
   │  │  ├── GeneratedPluginRegistrant.swift
   │  │  ├── Flutter-Release.xcconfig
   │  │  └── ephemeral
   │  │    ├── flutter_export_environment.sh
   │  │    ├── flutter_native_integration.env
   │  │    ├── Packages
   │  │     │  ├── .packages
   │  │     │  │  └── FlutterFramework
   │  │     │  │    ├── Package.swift
   │  │     │  │    └── Sources
   │  │     │  │       └── FlutterFramework
   │  │     │  │          └── FlutterFramework.swift
   │  │     │  └── FlutterGeneratedPluginSwiftPackage
   │  │     │    ├── Package.swift
   │  │     │    └── Sources
   │  │     │       └── FlutterGeneratedPluginSwiftPackage
   │  │     │          └── FlutterGeneratedPluginSwiftPackage.swift
   │  │    └── Flutter-Generated.xcconfig
   │  └── .gitignore
  ├── test
   │  └── widget_test.dart
  ├── .metadata
  ├── web
   │  ├── index.html
   │  ├── favicon.png
   │  ├── icons
   │  │  ├── Icon-192.png
   │  │  ├── Icon-maskable-192.png
   │  │  ├── Icon-maskable-512.png
   │  │  └── Icon-512.png
   │  └── manifest.json
  ├── .continue
   │  └── mcpServers
   │    └── new-mcp-server.yaml
  ├── pubspec.lock
  ├── ios
   │  ├── Runner.xcworkspace
   │  │  ├── contents.xcworkspacedata
   │  │  └── xcshareddata
   │  │    ├── IDEWorkspaceChecks.plist
   │  │    ├── WorkspaceSettings.xcsettings
   │  │    └── swiftpm
   │  │       └── configuration
   │  ├── RunnerTests
   │  │  └── RunnerTests.swift
   │  ├── Runner
   │  │  ├── Runner-Bridging-Header.h
   │  │  ├── Assets.xcassets
   │  │  │  ├── LaunchImage.imageset
   │  │  │  │  ├── LaunchImage@2x.png
   │  │  │  │  ├── LaunchImage@3x.png
   │  │  │  │  ├── README.md
   │  │  │  │  ├── Contents.json
   │  │  │  │  └── LaunchImage.png
   │  │  │  └── AppIcon.appiconset
   │  │  │    ├── Icon-App-76x76@2x.png
   │  │  │    ├── Icon-App-29x29@1x.png
   │  │  │    ├── Icon-App-40x40@1x.png
   │  │  │    ├── Icon-App-20x20@1x.png
   │  │  │    ├── Icon-App-1024x1024@1x.png
   │  │  │    ├── Icon-App-83.5x83.5@2x.png
   │  │  │    ├── Icon-App-20x20@3x.png
   │  │  │    ├── Contents.json
   │  │  │    ├── Icon-App-20x20@2x.png
   │  │  │    ├── Icon-App-29x29@3x.png
   │  │  │    ├── Icon-App-40x40@2x.png
   │  │  │    ├── Icon-App-60x60@3x.png
   │  │  │    ├── Icon-App-60x60@2x.png
   │  │  │    ├── Icon-App-76x76@1x.png
   │  │  │    ├── Icon-App-40x40@3x.png
   │  │  │    └── Icon-App-29x29@2x.png
   │  │  ├── GeneratedPluginRegistrant.h
   │  │  ├── Base.lproj
   │  │  │  ├── LaunchScreen.storyboard
   │  │  │  └── Main.storyboard
   │  │  ├── AppDelegate.swift
   │  │  ├── GeneratedPluginRegistrant.m
   │  │  ├── Info.plist
   │  │  └── SceneDelegate.swift
   │  ├── Runner.xcodeproj
   │  │  ├── project.pbxproj
   │  │  ├── project.xcworkspace
   │  │  │  ├── contents.xcworkspacedata
   │  │  │  └── xcshareddata
   │  │  │    ├── IDEWorkspaceChecks.plist
   │  │  │    ├── WorkspaceSettings.xcsettings
   │  │  │    └── swiftpm
   │  │  │       └── configuration
   │  │  └── xcshareddata
   │  │    └── xcschemes
   │  │       └── Runner.xcscheme
   │  ├── Flutter
   │  │  ├── flutter_export_environment.sh
   │  │  ├── Debug.xcconfig
   │  │  ├── Release.xcconfig
   │  │  ├── AppFrameworkInfo.plist
   │  │  ├── Generated.xcconfig
   │  │  └── ephemeral
   │  │    ├── flutter_lldbinit
   │  │    ├── flutter_lldb_helper.py
   │  │    ├── flutter_native_integration.env
   │  │    └── Packages
   │  │       ├── .packages
   │  │        │  └── FlutterFramework
   │  │        │    ├── Package.swift
   │  │        │    ├── Sources
   │  │        │     │  └── FlutterFramework
   │  │        │     │    └── FlutterFramework.swift
   │  │        │    └── .swiftpm
   │  │        │       └── xcode
   │  │       └── FlutterGeneratedPluginSwiftPackage
   │  │          ├── Package.swift
   │  │          ├── Sources
   │  │           │  └── FlutterGeneratedPluginSwiftPackage
   │  │           │    └── FlutterGeneratedPluginSwiftPackage.swift
   │  │          └── .swiftpm
   │  │             └── xcode
   │  └── .gitignore
  ├── README.md
  ├── pubspec.yaml
  ├── .gitignore
  ├── linux
   │  ├── CMakeLists.txt
   │  ├── runner
   │  │  ├── main.cc
   │  │  ├── CMakeLists.txt
   │  │  ├── my_application.h
   │  │  └── my_application.cc
   │  ├── flutter
   │  │  ├── generated_plugin_registrant.cc
   │  │  ├── CMakeLists.txt
   │  │  ├── generated_plugins.cmake
   │  │  └── generated_plugin_registrant.h
   │  └── .gitignore
  ├── android
   │  ├── app
   │  │  ├── build.gradle.kts
   │  │  └── src
   │  │    ├── profile
   │  │     │  └── AndroidManifest.xml
   │  │    ├── main
   │  │     │  ├── res
   │  │     │  │  ├── mipmap-mdpi
   │  │     │  │  │  └── ic_launcher.png
   │  │     │  │  ├── mipmap-hdpi
   │  │     │  │  │  └── ic_launcher.png
   │  │     │  │  ├── drawable
   │  │     │  │  │  └── launch_background.xml
   │  │     │  │  ├── mipmap-xxxhdpi
   │  │     │  │  │  └── ic_launcher.png
   │  │     │  │  ├── mipmap-xxhdpi
   │  │     │  │  │  └── ic_launcher.png
   │  │     │  │  ├── values-night
   │  │     │  │  │  └── styles.xml
   │  │     │  │  ├── values
   │  │     │  │  │  └── styles.xml
   │  │     │  │  ├── drawable-v21
   │  │     │  │  │  └── launch_background.xml
   │  │     │  │  └── mipmap-xhdpi
   │  │     │  │    └── ic_launcher.png
   │  │     │  ├── AndroidManifest.xml
   │  │     │  ├── java
   │  │     │  │  └── io
   │  │     │  │    └── flutter
   │  │     │  │       └── plugins
   │  │     │  │          └── GeneratedPluginRegistrant.java
   │  │     │  └── kotlin
   │  │     │    └── com
   │  │     │       └── example
   │  │     │          └── pharmacustomer_app
   │  │     │             └── MainActivity.kt
   │  │    └── debug
   │  │       └── AndroidManifest.xml
   │  ├── pharmacustomer_app_android.iml
   │  ├── local.properties
   │  ├── gradle
   │  │  └── wrapper
   │  │    ├── gradle-wrapper.jar
   │  │    └── gradle-wrapper.properties
   │  ├── gradlew
   │  ├── .gitignore
   │  ├── build.gradle.kts
   │  ├── settings.gradle.kts
   │  ├── gradle.properties
   │  └── gradlew.bat
  ├── lib
   │  ├── core
   │  │  └── theme.dart
   │  ├── app
   │  │  └── app.dart
   │  ├── features
   │  │  ├── home
   │  │  │  ├── main_nav_wrapper.dart
   │  │  │  ├── search_screen.dart
   │  │  │  └── home_screen.dart
   │  │  ├── auth
   │  │  │  ├── login_screen.dart
   │  │  │  └── otp_screen.dart
   │  │  └── onboarding
   │  │    ├── profile_setup_screen.dart
   │  │    └── splash_screen.dart
   │  └── main.dart
  ├── analysis_options.yaml
  ├── .dart_tool
   │  ├── package_config.json
   │  ├── extension_discovery
   │  │  ├── README.md
   │  │  └── vs_code.json
   │  ├── flutter_build
   │  │  ├── 89e0e436f29c132bae235c494499dcfe
   │  │  │  ├── debug_unpack_ios.stamp
   │  │  │  ├── outputs.json
   │  │  │  └── .filecache
   │  │  └── 60a69538c41a8c99a75ac259da0c48c7
   │  │    ├── debug_universal_framework.stamp
   │  │    ├── debug_ios_lldb_init.stamp
   │  │    ├── gen_localizations.stamp
   │  │    ├── install_code_assets.stamp
   │  │    ├── app.dill
   │  │    ├── debug_unpack_ios.stamp
   │  │    ├── kernel_snapshot_program.d
   │  │    ├── outputs.json
   │  │    ├── dart_build.stamp
   │  │    ├── install_code_assets.d
   │  │    ├── gen_dart_plugin_registrant.stamp
   │  │    ├── App.framework
   │  │     │  └── App
   │  │    ├── dart_build_result.json
   │  │    ├── flutter_assets.d
   │  │    ├── debug_ios_bundle_flutter_assets.stamp
   │  │    ├── kernel_snapshot_program.stamp
   │  │    ├── native_assets.json
   │  │    ├── IssueLaunchRootViewControllerAccess.stamp
   │  │    ├── dart_build.d
   │  │    └── .filecache
   │  ├── package_graph.json
   │  ├── dartpad
   │  │  └── web_plugin_registrant.dart
   │  └── version
  └── windows
     ├── CMakeLists.txt
     ├── runner
      │  ├── flutter_window.cpp
      │  ├── utils.h
      │  ├── utils.cpp
      │  ├── runner.exe.manifest
      │  ├── CMakeLists.txt
      │  ├── win32_window.h
      │  ├── win32_window.cpp
      │  ├── resources
      │  │  └── app_icon.ico
      │  ├── resource.h
      │  ├── Runner.rc
      │  ├── main.cpp
      │  └── flutter_window.h
     ├── flutter
      │  ├── generated_plugin_registrant.cc
      │  ├── CMakeLists.txt
      │  ├── generated_plugins.cmake
      │  └── generated_plugin_registrant.h
     └── .gitignore
```

