{ unstable, ... }:

{
  home.packages = [
    unstable.walker
    unstable.elephant
  ];

  systemd.user.services.elephant = {
    Unit = {
      Description = "Elephant application launcher backend";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${unstable.elephant}/bin/elephant";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
