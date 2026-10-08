{ ... }:
{
  boot.kernel.sysctl."vm.swappiness" = 100;
  
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=33"
    "zswap.zpool=zsmalloc"
  ];

  swapDevices = [ {
    device = "/swap/swapfile";
    size = 8 * 1024;
  } ];
  
  systemd.oomd.enable = true;
}
