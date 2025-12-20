{
  config,
  pkgs,
  lib,
  ...
}: let
  # Compose minimal Android SDK + tools, as the entirety of androidsdk
  # took too much space
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    platformVersions = ["36"];
    platformToolsVersion = ["36.0.0"];
    buildToolsVersions = ["36.0.0"];
    abiVersions = ["x86_64" "arm64-v8a"];
    includeEmulator = false;
    includeSystemImages = false;
    includeNDK = false;
    toolsVersion = "26.1.1";
  };
  SDKroot = "${androidComposition.androidsdk}/libexec/android-sdk";
in {
  home.packages = [
    androidComposition.androidsdk
  ];

  home.sessionVariables = {
    ANDROID_HOME = SDKroot;
    ANDROID_SDK_ROOT = SDKroot;
  };

  home.sessionPath = [
    "${SDKroot}/cmdline-tools/latest/bin"
    "${SDKroot}/platform-tools"
  ];
}
