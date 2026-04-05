{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.fprintd = {
    enable = true;
  };

  # Keep password auth in the normal login stack. GDM uses its own
  # gdm-fingerprint PAM service for fingerprint login.
  security.pam.services.login.fprintAuth = false;
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.gdm.fprintAuth = true;
  security.pam.services.gdm-password.fprintAuth = true;

  # Workaround the GDM/PAM ordering issue where enabling fprintd can make
  # the graphical greeter behave like fingerprint-only auth.
  # https://github.com/NixOS/nixpkgs/issues/171136
  security.pam.services.gdm-fingerprint = lib.mkIf config.services.fprintd.enable {
    text = ''
      auth       required                    pam_shells.so
      auth       requisite                   pam_nologin.so
      auth       requisite                   pam_faillock.so      preauth
      auth       required                    ${config.services.fprintd.package}/lib/security/pam_fprintd.so
      auth       optional                    pam_permit.so
      auth       required                    pam_env.so conffile=/etc/pam/environment readenv=0
      auth       [success=ok default=1]      ${pkgs.gdm}/lib/security/pam_gdm.so
      auth       optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so

      account    include                     login

      password   required                    pam_deny.so

      session    include                     login
      session    optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
    '';
  };
}
