{ pkgs, inputs, ... }:
{
  users.mutableUsers = true;
  users.groups = {
    sez = {
      gid = 1000;
      name = "sez";
    };
  };
  users.users.sez = {
    uid = 1000;
    home = "/home/sez";
    isNormalUser = true;
    name = "sez";
    group = "sez";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      inputs.schlag-o-meterer.packages."${pkgs.system}".default
    ];
  };

  sez.schlag-o-meterer.enable = true;

  system.stateVersion = "24.05";
}
