{
  pkgs,
  lib,
  config,
  ...
}: let
  studioVersion = "2026.1.4.7";
  ideaVersion = "2026.1.4";
  buildToolsVersion = "37.0.0";

  # Google ships no aarch64-linux build-tools/platform-tools. These are built from AOSP source:
  # https://github.com/HomuHomu833/android-sdk-custom
  nativeSdk = pkgs.stdenv.mkDerivation {
    pname = "android-sdk-aarch64-linux-gnu";
    version = buildToolsVersion;
    src = pkgs.fetchurl {
      url = "https://github.com/HomuHomu833/android-sdk-custom/releases/download/${buildToolsVersion}/android-sdk-aarch64-linux-gnu.tar.xz";
      hash = "sha256-LtyYLhV6kE7mByAuiEVDaoHs1tPGW7pmqoRpUIfz0IM=";
    };
    nativeBuildInputs = [pkgs.autoPatchelfHook];
    buildInputs = [pkgs.stdenv.cc.cc.lib pkgs.zlib];
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out
      cp -r android-sdk/. $out/
    '';
  };

  platforms = (pkgs.androidenv.override {licenseAccepted = true;}).composeAndroidPackages {
    platformVersions = ["36" "37"];
    buildToolsVersions = [];
    includeEmulator = false;
  };

  sdk = pkgs.runCommand "android-sdk" {} ''
    mkdir -p $out
    cp -r ${nativeSdk}/. $out/
    chmod -R u+w $out
    ln -s ${platforms.androidsdk}/libexec/android-sdk/platforms $out/platforms
  '';

  studioSrc = pkgs.fetchurl {
    url = "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${studioVersion}/android-studio-quail4-linux.tar.gz";
    hash = "sha256-S+JACD31raKQl12H1g/CEqPTjU8lihJQmJiFqdvHmYA=";
  };

  # Donor for the aarch64 JBR and IntelliJ native libraries; must match Studio's IntelliJ platform build.
  ideaSrc = pkgs.fetchurl {
    url = "https://download.jetbrains.com/idea/idea-${ideaVersion}-aarch64.tar.gz";
    hash = "sha256-MDZFuLrUxcCIc0Zhi4QhgKPeU7Pgs9oJ/FxQH1n3gBM=";
  };

  # aarch64 layoutlib (Compose/XML preview), built from AOSP android17-release:
  # https://github.com/DesktopECHO/android-studio-aarch64-install/blob/main/BUILDING_LAYOUTLIB.md
  layoutlibRev = "2a002dfa063242f8fae089e370eafe9ff01c6297";
  layoutlibJni = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/DesktopECHO/android-studio-aarch64-install/${layoutlibRev}/lib/layoutlib_jni.so";
    hash = "sha256-jat3k4uWkqGZ1dxEUkRsvRVMsg4S/vP+hP7Msg3cW7U=";
  };
  layoutlibRuntime = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/DesktopECHO/android-studio-aarch64-install/${layoutlibRev}/lib/libandroid_runtime.so";
    hash = "sha256-EtswUVEsjRHAu8azErKSBU/VclwieWB3U6tHOmRcsR0=";
  };

  studioUnwrapped = pkgs.stdenv.mkDerivation {
    pname = "android-studio-unwrapped";
    version = studioVersion;
    srcs = [studioSrc ideaSrc];
    sourceRoot = ".";
    nativeBuildInputs = [pkgs.makeWrapper];
    dontPatchShebangs = true;
    dontFixup = true;
    installPhase = ''
      idea=$(ls -d idea-IU-*)
      mkdir -p $out
      cp -r android-studio/. $out/
      chmod -R u+w $out

      for rel in jbr bin/fsnotifier bin/restarter lib/jna lib/native lib/pty4j lib/skiko-awt-runtime-all; do
        rm -rf "$out/$rel"
        cp -r "$idea/$rel" "$out/$rel"
      done

      layoutlib=$out/plugins/design-tools/resources/layoutlib/data/linux/lib64
      install -m755 ${layoutlibJni} $layoutlib/layoutlib_jni.so
      install -m755 ${layoutlibRuntime} $layoutlib/libandroid_runtime.so

      rm $out/bin/studio
      sed -i 's|lib/jna/amd64|lib/jna/aarch64|g' $out/bin/studio.sh
      wrapProgram $out/bin/studio.sh \
        --set-default JAVA_HOME "$out/jbr" \
        --set _JAVA_AWT_WM_NONREPARENTING 1 \
        --set QT_XKB_CONFIG_ROOT "${pkgs.xkeyboard_config}/share/X11/xkb" \
        --prefix PATH : "${lib.makeBinPath (with pkgs; [coreutils findutils gnugrep which gnused file gnutar gzip git ps usbutils libsecret])}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath (with pkgs; [
        fontconfig
        freetype
        libxext
        libxi
        libxrender
        libxtst
        libsecret
        e2fsprogs
        stdenv.cc.cc.lib
        zlib
        libxrandr
        alsa-lib
        dbus
        expat
        libbsd
        libpulseaudio
        libuuid
        libx11
        libxcb
        libxkbcommon
        libxcb-wm
        libxcb-render-util
        libxcb-keysyms
        libxcb-image
        libxcb-cursor
        libice
        libsm
        libxkbfile
        libxcomposite
        libxcursor
        libxdamage
        libxfixes
        libGL
        libdrm
        libpng
        nspr
        nss_latest
        systemd
        gtk3
        glib
        wayland
      ])}"
    '';
  };

  fhsEnv = pkgs.buildFHSEnv {
    pname = "android-studio-fhs-env";
    version = studioVersion;
    targetPkgs = p: [p.ncurses5];
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "android-studio";
    exec = "android-studio %f";
    icon = "android-studio";
    desktopName = "Android Studio";
    categories = ["Development" "IDE"];
    startupWMClass = "jetbrains-studio";
  };

  # AGP 9 fetches an x86_64 aapt2 from Maven; the property points it at the native one.
  studio = pkgs.runCommand "android-studio-${studioVersion}" {} ''
    mkdir -p $out/bin $out/share/pixmaps
    cat > $out/bin/android-studio <<EOF
    #!${pkgs.runtimeShell}
    export ANDROID_HOME="\''${ANDROID_HOME-${sdk}}"
    export ANDROID_SDK_ROOT="\$ANDROID_HOME"
    exec ${pkgs.coreutils}/bin/env \
      "ORG_GRADLE_PROJECT_android.aapt2FromMavenOverride=\$ANDROID_HOME/build-tools/${buildToolsVersion}/aapt2" \
      ${lib.getExe fhsEnv} ${studioUnwrapped}/bin/studio.sh "\$@"
    EOF
    chmod +x $out/bin/android-studio
    ln -s ${studioUnwrapped}/bin/studio.png $out/share/pixmaps/android-studio.png
    ln -s ${desktopItem}/share/applications $out/share/applications
  '';
in {
  options.android-studio.enable = lib.mkEnableOption "Android Studio with native aarch64 SDK tools";

  config = lib.mkIf config.android-studio.enable {
    # USB adb works without programs.adb/adbusers on nixbook; add them only if a device reports "no permissions".
    environment.systemPackages = [studio];
    environment.sessionVariables.ANDROID_HOME = "${sdk}";
  };
}
