{...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      function dfinit() {
        nix flake init --template github:grapeofwrath/dev-templates#"$1"
      }
      function dfnew() {
        nix flake new --template github:grapeofwrath/dev-templates#"$1" "$2"
      }
    '';
    historyControl = [ "ignoredups" ];
    historyIgnore = [
      "ls"
      "ll"
      "cd"
      "z"
      ".."
      "exit"
    ];
  };
}
