{ ... }:
{
  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25" "netrom" "rose"
    # Old or rare or insufficiently audited filesystems
    "adfs"     "affs"  "bfs"    "befs"
    "cramfs"   "efs"   "erofs"  "exofs"
    "freevxfs" "f2fs"  "hfs"    "hpfs"
    "jfs"      "minix" "nilfs2" "ntfs"
    "omfs"     "qnx4"  "qnx6"   "sysv"
    "ufs"
  ];

  boot.kernel.sysctl = {
    "fs.suid_dumpable"                       = 0;
    "kernel.dmesg_restrict"                  = 1;
    "kernel.ftrace_enabled"                  = false;
    "kernel.io_uring_disabled"               = 2;
    "kernel.kptr_restrict"                   = 2;
    "kernel.sysrq"                           = 0;
    "kernel.unprivileged_bpf_disabled"       = 1;
    "kernel.yama.ptrace_scope"               = 1;
    "net.core.bpf_jit_enable"                = false;
    "net.ipv4.conf.all.accept_redirects"     = false;
    "net.ipv4.conf.all.log_martians"         = true;
    "net.ipv4.conf.all.secure_redirects"     = false;
    "net.ipv4.conf.all.send_redirects"       = false;
    "net.ipv4.conf.default.accept_redirects" = false;
    "net.ipv4.conf.default.log_martians"     = true;
    "net.ipv4.conf.default.secure_redirects" = false;
    "net.ipv4.conf.default.send_redirects"   = false;
    "net.ipv4.icmp_echo_ignore_broadcasts"   = true;
    "net.ipv4.tcp_rfc1337"                   = 1;
    "net.ipv6.conf.all.accept_redirects"     = false;
    "net.ipv6.conf.default.accept_redirects" = false;

    # WireGuard/Tailscale policy routing require `rp_filter = 2;`.
    "net.ipv4.conf.all.rp_filter"     = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
  };

  boot.kernelParams = [
    "slab_nomerge"
    "page_poison=1"
    "page_alloc.shuffle=1"
    "debugfs=off"
  ];

  security.protectKernelImage = true;
}
