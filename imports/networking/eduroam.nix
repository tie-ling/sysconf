{
  networking = {
    openconnect = {
      interfaces = {
        tub = {
          autoStart = true;
          gateway = "vpn.tu-berlin.de";
          protocol = "anyconnect";
          user = "yguo@tu-berlin.de";
          passwordFile = "/old/home/yc/vpn.txt";
        };
      };
    };
    wireless = {
      environmentFile = "/home/yc/Documents/wifipass.txt";
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
