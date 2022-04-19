{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    fail2ban = {
      enable = true;
      jails = {
        apache-nohome-iptables = ''
          # Block an IP address if it accesses a non-existent
          # home directory more than 5 times in 10 minutes,
          # since that indicates that it's scanning.
          filter   = apache-nohome
          action   = iptables-multiport[name=HTTP, port="http,https"]
          logpath  = /var/log/httpd/error_log*
          findtime = 600
          bantime  = 600
          maxretry = 5
        '';
      };
      bantime-increment.enable = true;
    };
  };
}
