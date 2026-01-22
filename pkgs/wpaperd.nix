{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  wayland,
  libGL,
  dav1d,
  installShellFiles,
  scdoc,
  rust-jemalloc-sys,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wpaperd";
  version = "7a0fbc954a3009f522e664ce7a6f261ecbf1b172";

  src = fetchFromGitHub {
    owner = "danyspin97";
    repo = "wpaperd";
    # tag = finalAttrs.version;
    rev = finalAttrs.version;
    hash = "sha256-WByb493PT3RcH9RH/VQTabjQUC1jgXO12ZXMSZgoS0M=";
  };

  cargoHash = "sha256-Vz5x9V+q5OwRR/GdiM/kEEfENSQ+KyN3DKM35NHuzAk=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    scdoc
  ];
  buildInputs = [
    wayland
    libGL
    libxkbcommon
    dav1d
    rust-jemalloc-sys
  ];

  buildFeatures = [
    "avif"
  ];

  postBuild = ''
    scdoc < man/wpaperd-output.5.scd > man/wpaperd-output.5
  '';

  postInstall = let
    targetDir = "target/*/$cargoBuildType";
  in ''
    installShellCompletion ${targetDir}/completions/*.{bash,fish}
    installShellCompletion --zsh ${targetDir}/completions/_*
    installManPage ${targetDir}/man/*.1 man/*.5
  '';

  meta = {
    description = "Minimal wallpaper daemon for Wayland";
    longDescription = ''
      It allows the user to choose a different image for each output (aka for each monitor)
      just as swaybg. Moreover, a directory can be chosen and wpaperd will randomly choose
      an image from it. Optionally, the user can set a duration, after which the image
      displayed will be changed with another random one.
    '';
    homepage = "https://github.com/danyspin97/wpaperd";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      DPDmancul
      fsnkty
    ];
    mainProgram = "wpaperd";
  };
})
