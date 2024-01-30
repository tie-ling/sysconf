{
  networking.firewall = {
    # ports are also opened by other programs
    allowedTCPPorts = [
      # nfsv4
      2049
    ];
    allowedUDPPorts = [ ];
  };
}
