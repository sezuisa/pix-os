{ pkgs, ... }:
{
  networking = {
    hostName = "irrenpi";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        23235
      ];
      allowedUDPPorts = [
        23235
      ];
    };

    # useDHCP = true;
    interfaces.wlan0 = {
      useDHCP = true;
      #ipv4.addresses = [{
      # I used static IP over WLAN because I want to use it as local DNS resolver
      #address = "192.168.1.4";
      #prefixLength = 24;
      #}];
    };
    interfaces.eth0 = {
      useDHCP = true;
      # I used DHCP because sometimes I disconnect the LAN cable
      #ipv4.addresses = [{
      #  address = "192.168.100.3";
      #  prefixLength = 24;
      #}];
    };

    # Enabling WIFI
    # wireless.enable = true;
    # wireless.interfaces = [ "wlan0" ];
    # If you want to connect also via WIFI to your router
    # wireless.networks."SATRIA".psk = "wifipassword";
    # You can set default nameservers
    # nameservers = [ "192.168.100.3" "192.168.100.4" "192.168.100.1" ];
    # You can set default gateway
    # defaultGateway = {
    #  address = "192.168.1.1";
    #  interface = "eth0";
    # };
  };
  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ pkgs.wireless-regdb ];
  };
}
