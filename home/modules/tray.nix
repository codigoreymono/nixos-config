{
  services.status-notifier-watcher.enable = true;

  systemd.user.targets.tray = {
    Unit.PartOf = [ "graphical-session.target" ];

    Install.WantedBy = [
      "graphical-session.target"
    ];
  };
}
