{
  networking = {
    firewall.enable = true;
    useDHCP = true;
    useNetworkd = true;
    hosts = { "200:8bcd:55f4:becc:4d85:2fa6:2ed2:5eba" = [ "tl.yc" ]; };
    wireless = {
      enable = true;
      allowAuxiliaryImperativeNetworks = true;
      userControlled = {
        enable = true;
        group = "wheel";
      };
      networks = {
        "TP-Link_48C2".psk = "77017543";
        "1203-5G".psk = "woxiangshuoqinaidemaizi";
        # public network
        # "_Free_Wifi_Berlin" = {};
      };
    };
  };
  systemd.services.wpa_supplicant.wantedBy = [ "multi-user.target" ];
  systemd.network = {
    enable = true;
    networks = {
      "99-ethernet-default-dhcp" = {
        dns = [ "[::1]:53" ];
        dhcpV4Config = { UseDNS = false; };
        dhcpV6Config = { UseDNS = false; };
        ipv6AcceptRAConfig = { UseDNS = false; };
      };
      "99-wireless-client-dhcp" = {
        dns = [ "[::1]:53" ];
        dhcpV4Config = { UseDNS = false; };
        dhcpV6Config = { UseDNS = false; };
        ipv6AcceptRAConfig = { UseDNS = false; };
      };
    };
  };
}
