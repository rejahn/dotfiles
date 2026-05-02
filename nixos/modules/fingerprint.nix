{
  ...
}:

{
  # Keep fingerprint auth disabled on this laptop until the GDM/PAM path is
  # intentionally configured and tested end-to-end.
  services.fprintd.enable = false;

  security.pam.services.login.fprintAuth = false;
  security.pam.services.sudo.fprintAuth = false;
  security.pam.services.gdm.fprintAuth = false;
  security.pam.services.gdm-password.fprintAuth = false;
}
