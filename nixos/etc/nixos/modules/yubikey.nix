{ pkgs, ... }:

{
  # ykman uses pcscd for smartcard-backed applications on the YubiKey.
  services.pcscd.enable = true;

  security.pam.u2f = {
    enable = true;
    control = "sufficient";
    settings = {
      cue = true;
    };
  };

  # Allow sudo to authenticate with a registered U2F/FIDO credential.
  security.pam.services.sudo.u2fAuth = true;

  environment.systemPackages = with pkgs; [
    yubikey-manager
  ];
}
