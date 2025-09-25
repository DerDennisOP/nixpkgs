{
  buildDotnetModule,
  dotnetCorePackages,
  unreal-source,
}:

buildDotnetModule {
  pname = "unreal-engine_5-ubt";
  version = "5.7.0-preview-1";
  src = unreal-source;
  dotnet-sdk = dotnetCorePackages.sdk_8_0-bin;
  projectFile = "Engine/Source/Programs/UnrealBuildTool/UnrealBuildTool.csproj";
  nugetDeps = ./deps.json; # File generated with `nix-build -A unreal-engine_5.fetch-deps`.

  configurePhase = ''
    # mkdir -p ../Intermediate/Build

    # DEPENDS_FILE=../Intermediate/Build/UnrealBuildTool.dep.csv
    # TEMP_DEPENDS_FILE=$(mktemp)

    # "$SCRIPT_DIR/DotnetDepends.sh" Programs/UnrealBuildTool/UnrealBuildTool.sln "$TEMP_DEPENDS_FILE"
    $preConfigurePhases
  '';
}
