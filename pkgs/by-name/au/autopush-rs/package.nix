{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  pkg-config,
  cmake,
  openssl,
  libffi,
  grpc,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autopush";
  version = "1.81.3";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "autopush-rs";
    tag = finalAttrs.version;
    hash = "sha256-DP02mcEMoQoJqi5rw5eSuep0i7zeJ0LLYsakikt9hho=";
  };

  cargoHash = "sha256-LqmuUtFF30TO6iw7LPFB7yJGrzrhh7R0OKCWMhe/OjU=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    cmake
  ];

  buildInputs = [
    openssl
    libffi
    grpc
  ];

  env = {
    #needed for bingen to find libc
    BINDGEN_EXTRA_CLANG_ARGS = "-I${stdenv.cc.libc.dev}/include";
    CMAKE_POLICY_VERSION_MINIMUM = "3.5";
  };

  #check build fails
  doCheck = false;

  passthru.tests = {
  };

  passthru.services.default = {
    imports = [ (lib.modules.importApply ./service.nix) ];
    autopush-rs.package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Mozilla Push server and Push Endpoint";
    homepage = "https://mozilla-services.github.io/autopush-rs/index.html";
    changelog = "https://github.com/mozilla-services/autopush-rs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = [
      lib.maintainers.zimward
    ];
  };
})
