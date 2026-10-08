# ===============================================================
# This configuration assumes a btrfs root partition to exist at
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
# === NB! ===
# You must run `nixos-generate-config --show-hardware-config > hardware-configuration.nix`
# to generate a `hardware-configuration.nix` for your own system.
# The following section can be copied into that file to handle
# mounting btrfs subvolumes with correct compression and nocow
# options.
# ===
#
# You can mount aditional container subvolumes in 
# `local-configuration.nix`, using
# `services.btrfsContainerSubvolumes` (see `modules/btrfs.nix`).
# ===============================================================

{ ... }:
let
  btrfsLabel = "BTRFS";
  mountOpts  = [ "compress=zstd" "noatime" ];

  mkCompressedVol = { subvol, path ? null }:
  let
    mount = if path == null then "/${subvol}" else path;
  in {
    fileSystems.${mount} = {
      device  = "/dev/disk/by-label/${btrfsLabel}";
      fsType  = "btrfs";
      options = [ "subvol=@${subvol}" ] ++ mountOpts;
    };
  };

  mkNocowVol = { subvol, path ? null }:
  let
    mount = if path == null then "/${subvol}" else path;
  in {
    fileSystems.${mount} = {
      device  = "/dev/disk/by-label/${btrfsLabel}";
      fsType  = "btrfs";
      options = [ "subvol=@${subvol}" ] ++ mountOpts;
    };
    systemd.tmpfiles.rules = [
      "H ${mount} - - - - +C"
    ];
  };
in {
  imports = [
    ( mkCompressedVol { subvol="";     } )
    ( mkCompressedVol { subvol="home"; } )
    ( mkCompressedVol { subvol="nix";  } )
    ( mkNocowVol      { subvol="tmp";  } )
    ( mkNocowVol      { subvol="swap"; } )
    ( mkCompressedVol { subvol="var";  } )
    
    ( mkCompressedVol { subvol="containers"; path="/srv/containers"; } )
    ( mkNocowVol      { subvol="docker";     path="/var/lib/docker"; } )
    ( mkCompressedVol { subvol="logs";       path="/var/log";        } )
    ( mkCompressedVol { subvol="snapshots";  path="/.snapshots";     } )
  ];
}
