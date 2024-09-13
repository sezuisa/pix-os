{ pkgs, inputs, config, lib, ssh-keys, ... }:
let
  schlago = inputs.schlag-o-meterer.packages."${pkgs.system}".default;
  schlago-path = "/var/lib/schlag-o-meter";
  pubkeysFile = pkgs.writeText "pubkeys" ''
    ${ssh-keys.ssh-key-schlago}
  '';
in
{
  options.sez.schlag-o-meterer = {
    enable = lib.mkEnableOption "schlag-o-meterer backend service";
  };

  config = lib.mkIf (config.sez.schlag-o-meterer.enable)
    {
      /* schlag-o-meterer service user */
      users.users.schlago = {
        group = "schlago";
        isSystemUser = true;
      };
      users.groups.schlago = { };

      /* create schlag-o-meter directory */
      systemd.tmpfiles.settings."schlag-o-meter" = {
        "${schlago-path}".d = {
          mode = "0770";
          user = "schlago";
          group = "schlago";
        };
      };

      /* schlag-o-meterer service */
      systemd.services.schlag-o-meter = {
        description = "Schlag-O-Meterer - Backend for Schlag-O-Meter counter";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        stopIfChanged = false;
        startLimitIntervalSec = 60;
        environment = {
          SSH_HOST = "0.0.0.0";
          SSH_PUBKEY_FILE = "${pubkeysFile}";
        };
        serviceConfig = {
          ExecStart = "${schlago}/bin/schlag-o-meter";
          WorkingDirectory = "${schlago-path}";
          Restart = "always";
          RestartSec = "10s";
          User = "schlago";
          Group = "schlago";
        };
      };
    };
}
