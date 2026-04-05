{ ... }:

{
  # Plymouth boot splash
  boot.initrd.systemd.enable = true;
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };
}
