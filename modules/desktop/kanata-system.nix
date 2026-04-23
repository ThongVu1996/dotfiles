{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.myConfig.desktop.kanata;
in {
  options.myConfig.desktop.kanata = {
    enable = lib.mkEnableOption "Enable Kanata (System Daemon for low latency)";
  };

  config = lib.mkIf cfg.enable {
    # Install kanata package system-wide
    environment.systemPackages = [pkgs.kanata];

    # Deploy the configuration file to /etc/kanata/config.kbd
    # System daemons have reliable access to /etc
    environment.etc."kanata/config.kbd".source = ./kanata/config.kbd;

    # Define the system-level LaunchDaemon
    # Running as a system daemon (root) is the key to low latency and 
    # avoiding IOHIDDeviceOpen privilege errors on modern macOS (like Sequoia).
    launchd.daemons.kanata = {
      command = "/bin/sh -c 'sleep 5 && exec ${pkgs.kanata}/bin/kanata --cfg /etc/kanata/config.kbd --port 10000'";
      serviceConfig = {
        Label = "com.kanata.kanata";
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/Library/Logs/kanata.out.log";
        StandardErrorPath = "/Library/Logs/kanata.err.log";
        # 'Interactive' tells macOS to prioritize this process for low latency
        ProcessType = "Interactive";
        # High priority to ensure smooth key event handling
        Nice = -15;
      };
    };

    # These additional daemons are required to manage the Virtual HID Device
    # as described in the low-latency implementation guide.
    launchd.daemons.karabiner-vhiddaemon = {
      command = "/Library/Application\\ Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
      serviceConfig = {
        Label = "com.karabiner.vhiddaemon";
        RunAtLoad = true;
        KeepAlive = true;
      };
    };

    launchd.daemons.karabiner-vhidmanager = {
      command = "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate";
      serviceConfig = {
        Label = "com.karabiner.vhidmanager";
        RunAtLoad = true;
      };
    };

    # Note: For best results on macOS Sequoia+, the user should also:
    # 1. Install Karabiner-DriverKit-VirtualHIDDevice (https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice)
    # 2. Grant 'Input Monitoring' and 'Accessibility' permissions to the kanata binary in System Settings.
    #    The binary path will be something like: /nix/store/...-kanata-.../bin/kanata
  };
}
