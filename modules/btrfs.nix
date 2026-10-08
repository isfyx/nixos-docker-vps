# ===============================================================
# This module assumes a btrfs root partition to exist at
# `/dev/disk/by-label/BTRFS` containing the following subvolumes:
# 
#   +=============+=================+
#   | Subvolume   | Mount path      |
#   +-------------+-----------------+
#   | @           | /               |
#   | @containers | /srv/containers |
#   | @docker     | /var/lib/docker |
#   | @home       | /home           |
#   | @logs       | /var/log        |
#   | @nix        | /nix            |
#   | @tmp        | /tmp            |
#   | @snapshots  | /.snapshots     |
#   | @swap       | /swap           |
#   | @var        | /var            |
#   +=============+=================+
#
# Additional container subvolumes can be added in
# `local-configuration.nix` with:
#
# ```nix
#   services.btrfsContainerSubvolumes = [
#     "nginx"
#     "postgres"
#     "redis"
#   ];
# ```
# ===============================================================

{ config, lib, ... }:
let
  btrfsLabel = "BTRFS";
  cfg        = config.services.btrfsContainerSubvolumes;

  mkContainerSubvol = name: {
    name  = "/srv/containers/${name}";
    value = {
      device  = "/dev/disk/by-label/${btrfsLabel}";
      fsType  = "btrfs";
      options = [
        "subvol=@containers/@${name}"
        "compress=zstd"
        "noatime"
        "x-systemd.makefs"
        "x-systemd.automount"
      ];
      neededForBoot = false;
    };
  };

in {
  config = lib.mkIf (cfg != []) {
    fileSystems = builtins.listToAttrs (map mkContainerSubvol cfg);
  };

  options.services.btrfsContainerSubvolumes = lib.mkOption {
    type        = lib.types.listOf lib.types.str;
    default     = [];
    description = "List of container subvolumes to create under `/srv/containers/`.";
    example     = [ "nginx" "postgres" "redis" ];
  };
}
