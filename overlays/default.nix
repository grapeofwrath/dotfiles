{
  inputs,
  nixpkgs,
  system,
  ...
}: {
  # This one brings our custom packages from the 'pkgs' directory
  #additions = final: _prev: import ../pkgs final.pkgs;

  additional = final: _prev: {
    hyprpanel = inputs.hyprpanel.overlay.${final.system};
  };
  # hyprpanel = final: _prev: inputs.hyprpanel.overlay.${final.system};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  pkgs = import nixpkgs {
    inherit system;
    overlays = [
      inputs.hyprpanel.overlay.${system}
    ];
  };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
