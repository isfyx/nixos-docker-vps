{ ... }:
{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    daemon.settings  = {
      icc = false;
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
      no-new-privileges = true;
      userland-proxy = false;
    };
  };
}
