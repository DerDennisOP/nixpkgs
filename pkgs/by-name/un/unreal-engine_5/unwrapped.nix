{
  callPackage,
  stdenv,
  unzip,
  fetchurl,
  unreal-source,
  lib,
  writeScript,
  writeText,
  dotnetPackages,
  linkFarmFromDrvs,
  ...
}:
let
  fhsenv = callPackage ./fhs { } {
    name = "build-unreal-engine_5";

    targetPkgs =
      pkgs: with pkgs; [
        which
        dotnet-sdk_8
        pkg-config
        mono
        git
        python3
        vulkan-tools
        openssl
        xdg-user-dirs
      ];

    osReleaseFile = writeText "os-release" ''
      NAME=NixOS
      ID=nixos
    '';

    runScript = "
      cat /etc/os-release
      ./Setup.sh
      ./GenerateProjectFiles.sh
      make
    ";
  };

  deps = import ./cdn-deps.nix { inherit fetchurl; };
  linkDeps = writeScript "link-deps.sh" (
    lib.concatMapStringsSep "\n" (
      hash:

      let
        prefix = lib.concatStrings (lib.take 2 (lib.stringToCharacters hash));
      in
      ''
        mkdir -p .git/ue5-gitdeps/${prefix}
        ln -s ${lib.getAttr hash deps} .git/ue5-gitdeps/${prefix}/${hash}
      ''
    ) (lib.attrNames deps)
  );

  clangBundledToolchain = fetchurl {
    url = "http://cdn.unrealengine.com/Toolchain_Linux/native-linux-v25_clang-18.1.0-rockylinux8.tar.xz";
    sha256 = "";
  };

  # From buildDotnetModule
  nugetDeps = linkFarmFromDrvs "unreal-engine_5-nuget-deps" (
    import ./nuget-deps.nix {
      fetchNuGet =
        {
          name,
          version,
          sha256,
        }:
        fetchurl {
          name = "nuget-${name}-${version}.nupkg";
          url = "https://www.nuget.org/api/v2/package/${name}/${version}";
          inherit sha256;
        };
    }
  );

in
stdenv.mkDerivation rec {
  pname = "unreal-engine_5-unwrapped";
  version = "5.7.0-preview-1";

  sourceRoot = "UnrealEngine-${version}-release";

  src = unreal-source;
  buildInputs = [ dotnetPackages.Nuget ];

  DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";
  DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
  UE_USE_SYSTEM_MONO = "1";
  UE_USE_SYSTEM_DOTNET = "1";

  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';

  configurePhase = ''
    export HOME=$(mktemp -d)
    export http_proxy="nodownloads"
    nuget sources Add -Name nixos -Source "$HOME/nixos"
    nuget init "${nugetDeps}" "$HOME/nixos"
    mkdir -p $HOME/.nuget/NuGet
    cp $HOME/.config/NuGet/NuGet.Config $HOME/.nuget/NuGet
    echo "Copy the symlinks for the gitdeps"
    ${linkDeps}
    cp ${./SetupDotnet.sh} Engine/Build/BatchFiles/Linux/SetupDotnet.sh
    mkdir -p .git/ue4-sdks/
    cp ${clangBundledToolchain} .git/ue4-sdks/v19_clang-11.0.1-centos7.tar.gz
  '';

  buildPhase = ''
    echo "Starting UE5 FHS"
    ${fhsenv}/bin/build-ue5
  '';

  installPhase = ''
    mkdir -p $out
    mv * $out/
  '';

  meta = {
    description = "A suite of integrated tools for game developers to design and build games, simulations, and visualizations";
    homepage = "https://www.unrealengine.com/en-US/unreal-engine-5";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.juliosueiras ];
  };
}
