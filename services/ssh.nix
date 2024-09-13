{ ssh-keys, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = true;

    /* allow root login for remote deploy aka. rebuild-switch  */
    settings.AllowUsers = [ "sez" "root" ];
    settings.PermitRootLogin = "yes";

    /* require public key authentication for better security */
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [ ssh-keys.ssh-key-main ];
  users.users.sez.openssh.authorizedKeys.keys = [ ssh-keys.ssh-key-main ];

  # run 'fastfetch' command on SSH logins
  programs.bash.interactiveShellInit = "fastfetch";
}
