build-android:
    flutter build appbundle --obfuscate --split-debug-info=build/app/outputs/symbols

build-ios:
    flutter build ipa --obfuscate --split-debug-info=build/app/outputs/symbols