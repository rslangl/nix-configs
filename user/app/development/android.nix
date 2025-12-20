{ pkgs, system }:
let
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
in
{
  androidSDK = androidComposition.androidsdk;
  androidEnv = {
      ANDROID_SDK_ROOT = androidComposition.androidsdk + "/libexec/android-sdk";
      PATH = androidComposition.androidsdk + "/libexec/android-sdk/cmdline-tools/latest/bin:" +
           androidComposition.androidsdk + "/libexec/android-sdk/platform-tools:" +
           ":${pkgs.stdenv.cc.cc}/bin";
    };

  home.packages = with pkgs; [androidSDK];
}
