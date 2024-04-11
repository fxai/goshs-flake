{
  description = "goshs flake";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs }:
    let

      # System types to support.
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in
    {

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {

          default = pkgs.buildGoModule rec {
            pname = "goshs";
            version = "0.3.7";
              src = pkgs.fetchFromGitHub {
                owner = "patrickhener";
                repo = pname;
                rev = "v${version}";
                hash = "sha256-XinE5kjisen7ilHfcXmi9XSdOGQlFLax+NpDcfoNzcQ=";
            };

            doCheck = false;  

            vendorHash = "sha256-1QymLIeEb4q7QRbB76LC+d7IEnH4IznUpYzmoZerTSE=";
          };
        });
    };
}
