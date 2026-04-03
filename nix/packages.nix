# nix/packages.nix — SatanClaw Agent package built with uv2nix
{ inputs, ... }: {
  perSystem = { pkgs, system, ... }:
    let
      satanclawVenv = pkgs.callPackage ./python.nix {
        inherit (inputs) uv2nix pyproject-nix pyproject-build-systems;
      };

      # Import bundled skills, excluding runtime caches
      bundledSkills = pkgs.lib.cleanSourceWith {
        src = ../skills;
        filter = path: _type:
          !(pkgs.lib.hasInfix "/index-cache/" path);
      };

      runtimeDeps = with pkgs; [
        nodejs_20 ripgrep git openssh ffmpeg
      ];

      runtimePath = pkgs.lib.makeBinPath runtimeDeps;
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        pname = "satanclaw-agent";
        version = "0.1.0";

        dontUnpack = true;
        dontBuild = true;
        nativeBuildInputs = [ pkgs.makeWrapper ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/satanclaw-agent $out/bin
          cp -r ${bundledSkills} $out/share/satanclaw-agent/skills

          ${pkgs.lib.concatMapStringsSep "\n" (name: ''
            makeWrapper ${satanclawVenv}/bin/${name} $out/bin/${name} \
              --suffix PATH : "${runtimePath}" \
              --set HERMES_BUNDLED_SKILLS $out/share/satanclaw-agent/skills
          '') [ "satanclaw" "satanclaw-agent" "satanclaw-acp" ]}

          runHook postInstall
        '';

        meta = with pkgs.lib; {
          description = "AI agent with advanced tool-calling capabilities";
          homepage = "https://github.com/NousResearch/satanclaw-agent";
          mainProgram = "satanclaw";
          license = licenses.mit;
          platforms = platforms.unix;
        };
      };
    };
}
