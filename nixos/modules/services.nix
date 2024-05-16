{config,lib,...}:
let cfg = config.orion.services; in {
  options.orion.services = {
  };
  config = {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
