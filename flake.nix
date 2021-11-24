{
  description = "Template for GHC-Vis";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell/master";
  };
  outputs = { self, nixpkgs, flake-utils, devshell, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        cwd = builtins.toString ./.;
        overlays = [ devshell.overlay ];
        pkgs = import nixpkgs { inherit system overlays; };

        haskellPackages = pkgs.haskellPackages;

        jailbreakUnbreak = pkg:
          pkgs.haskell.lib.doJailbreak (pkg.overrideAttrs (_: { meta = { }; }));

        packageName = "hs-oct-pipes";
      in with pkgs; {

        packages.${packageName} =
          haskellPackages.callCabal2nix packageName self rec {
            # Dependency overrides go here
          };

        defaultPackage = self.packages.${system}.${packageName};

        devShell = pkgs.devshell.mkShell {
          packages = [
            haskell-language-server
            ghcid
            cabal-install
            gtk3
            gsettings-desktop-schemas
            graphviz
            pkgconfig
            librsvg
          ];
          bash = {
            extra = ''
              export XDG_DATA_DIRS=$GSETTINGS_SCHEMAS:$GTK_SCHEMAS:$XDG_DATA_DIRS
            '';
            interactive = "";
          };
          env = [
            {
              name = "GSETTINGS_SCHEMAS";
              value = "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}";
            }
            {
              name = "GTK_SCHEMAS";
              value = "${gtk3}/share/gsettings-schemas/${gtk3.name}";
            }
          ];
        };
      });
}
