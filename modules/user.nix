{ config, lib, ... }:
{
  config.users.users.admin = {
    extraGroups  = [ "wheel" "docker" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys =
      config.services.authorizedAdminKeys;
  };

  options.services.authorizedAdminKeys = lib.mkOption {
    type        = lib.types.listOf lib.types.str;
    default     = [];
    description = ''
      List of SSH public keys authorized to log in as the admin user account.
    '';
  };
}
