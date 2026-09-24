{ ... }:

{
  services.jellyfin = {
    enable = true;


    openFirewall = false;

    hardwareAcceleration = {
      enable = true;
      type = "vaapi";
      device = "/dev/dri/renderD128";
    };

    transcoding = {
      enableHardwareEncoding = true;

      hardwareDecodingCodecs = {
        h264 = true;
        hevc = true;
        mpeg2 = true;
        vc1 = true;
        vp8 = true;


        vp9 = false;
        av1 = false;
        hevc10bit = false;
        hevcRExt10bit = false;
        hevcRExt12bit = false;
      };

      hardwareEncodingCodecs = {
        hevc = true;
        av1 = false;
      };

      enableToneMapping = false;
      enableIntelLowPowerEncoding = false;
    };
  };

  users.groups.media = { };


  users.users.reymono.extraGroups = [
    "media"
  ];

  users.users.jellyfin.extraGroups = [
    "video"
    "render"
    "media"
  ];

  systemd.tmpfiles.rules = [
    "d /srv/media        2750 reymono media -"
    "d /srv/media/movies 2750 reymono media -"
    "d /srv/media/shows  2750 reymono media -"
    "d /srv/media/videos 2750 reymono media -"
  ];

  systemd.services.jellyfin.environment = {
    LIBVA_DRIVER_NAME = "iHD";
  };
}
