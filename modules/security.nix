{ lib, ... }:
{
  nix.settings.allowed-users = [ "@users" ];

  security.apparmor.enable = true;
  # Should be overriden and enabled if all containers have valid AppArmor
  # profiles. Verify with
  # `docker inspect -f '{{.AppArmorProfile}}' <container>` before overriding in
  # `local-configuration.nix`. 
  security.apparmor.killUnconfinedConfinables = lib.mkDefault false;

  security.forcePageTableIsolation = true;
}
