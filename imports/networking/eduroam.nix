{
  networking = {
    openconnect = {
      interfaces = {
        tub = {
          autoStart = false;
          gateway = "vpn.tu-berlin.de";
          protocol = "anyconnect";
          user = "yguo@tu-berlin.de";
          passwordFile = "/old/home/yc/vpn.txt";
          extraOptions = {
            authgroup = "2-TU-Full-Tunnel";
          };
        };
      };
    };
    wireless = {
      environmentFile = "/old/home/yc/eduroam.txt";
      networks = {
        "eduroam" = {
          authProtocols = [ "WPA-EAP" ];
          auth = ''
            eap=PEAP
            ca_cert="/etc/ssl/certs/ca-certificates.crt"
            phase2="auth=MSCHAPV2"
            identity="yguo@tu-berlin.de"
            domain_suffix_match="tu-berlin.de"
            anonymous_identity="wlan@tu-berlin.de"
            password="@PASS_TU_BERLIN@"
          '';
        };
      };
    };
  };
}
