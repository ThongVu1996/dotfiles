{ pkgs, ... }:

let
  # Định nghĩa logic Gaps phức tạp cho từng màn hình
  outerGapsPerMonitor = [
    { monitor."Built-in Retina Display" = 0; }
    { monitor."secondary" = 25; }
    { monitor."DELL P2422H" = 10; }
    3 # Fallback value
  ];
in
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      after-login-command = [];
      after-startup-command = [];
      start-at-login = true;
      
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      
      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      on-focus-changed = "move-mouse monitor-lazy-center";
      
      automatically-unhide-macos-hidden-apps = false;

      key-mapping.preset = "qwerty";

      gaps = {
        inner.horizontal = 4;
        inner.vertical = 5;
        outer.left = outerGapsPerMonitor;
        outer.bottom = outerGapsPerMonitor;
        outer.top = outerGapsPerMonitor;
        outer.right = outerGapsPerMonitor;
      };

      mode.main.binding = {
        # --- KÍCH HOẠT CHẾ ĐỘ DI CHUYỂN ---
        "alt-q" = "mode move";
        # ----------------------------------

        "alt-backslash" = "layout tiles horizontal vertical";
        "alt-equal" = "layout accordion horizontal vertical";

        "alt-h" = "focus left";
        "alt-j" = "focus down";
        "alt-k" = "focus up";
        "alt-l" = "focus right";
        "alt-f" = "fullscreen";

        "alt-shift-h" = "move left";
        "alt-shift-j" = "move down";
        "alt-shift-k" = "move up";
        "alt-shift-l" = "move right";

        "alt-shift-minus" = "resize smart -50";
        "alt-shift-equal" = "resize smart +50";

        # Workspaces Switching
        "alt-a" = "workspace A"; 
        "alt-2" = "workspace B"; 
        "alt-1" = "workspace C"; 
        "alt-4" = "workspace D"; 
        "alt-5" = "workspace G"; 
        "alt-6" = "workspace M"; 
        "alt-n" = "workspace N"; 
        "alt-r" = "workspace R"; 
        "alt-s" = "workspace S"; 
        "alt-t" = "workspace T"; 
        "alt-3" = "workspace V"; 
        "alt-w" = "workspace W"; 
        "alt-x" = "workspace X"; 

        # Move to Workspaces (Giữ lại backup nếu muốn dùng cách cũ)
        "alt-shift-a" = "move-node-to-workspace A";
        "alt-shift-2" = "move-node-to-workspace B";
        "alt-shift-1" = "move-node-to-workspace C";
        "alt-shift-d" = "move-node-to-workspace D";
        "alt-shift-g" = "move-node-to-workspace G";
        "alt-shift-m" = "move-node-to-workspace M";
        "alt-shift-n" = "move-node-to-workspace N";
        "alt-shift-r" = "move-node-to-workspace R";
        "alt-shift-s" = "move-node-to-workspace S";
        "alt-shift-t" = "move-node-to-workspace T";
        "alt-shift-3" = "move-node-to-workspace V";
        "alt-shift-w" = "move-node-to-workspace W";
        "alt-shift-x" = "move-node-to-workspace X";

        "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";
        "alt-shift-semicolon" = "mode service";
      };

      # --- ĐỊNH NGHĨA CHẾ ĐỘ "MOVE" (Sau khi ấn Alt-Q) ---
      mode.move.binding = {
        # Ấn Esc để hủy
        esc = ["mode main"];

        # Logic: [ "Chuyển workspace" "Quay về mode main" ]
        # Chú ý: Mapping phải khớp với tên Workspace bạn định nghĩa ở trên (VD: 1 -> C)
        
        "1" = ["move-node-to-workspace C" "mode main"];
        "2" = ["move-node-to-workspace B" "mode main"];
        "3" = ["move-node-to-workspace V" "mode main"];
        "4" = ["move-node-to-workspace D" "mode main"];
        "5" = ["move-node-to-workspace G" "mode main"];
        "6" = ["move-node-to-workspace M" "mode main"];

        "a" = ["move-node-to-workspace A" "mode main"];
        "n" = ["move-node-to-workspace N" "mode main"];
        "r" = ["move-node-to-workspace R" "mode main"];
        "s" = ["move-node-to-workspace S" "mode main"];
        "t" = ["move-node-to-workspace T" "mode main"];
        "w" = ["move-node-to-workspace W" "mode main"];
        "x" = ["move-node-to-workspace X" "mode main"];
      };
      # ---------------------------------------------------

      mode.service.binding = {
        esc = ["reload-config" "mode main"];
        r = ["flatten-workspace-tree" "mode main"];
        f = ["layout floating tiling" "mode main"];
        backspace = ["close-all-windows-but-current" "mode main"];

        "alt-shift-h" = ["join-with left" "mode main"];
        "alt-shift-j" = ["join-with down" "mode main"];
        "alt-shift-k" = ["join-with up" "mode main"];
        "alt-shift-l" = ["join-with right" "mode main"];
      };

      workspace-to-monitor-force-assignment = {
        W = 1;
        C = "secondary";
        V = "main";
        B = "main";
        S = "main";
      };

      on-window-detected = [
        { "if".app-id = "com.github.wez.wezterm"; run = "move-node-to-workspace B"; }
        { "if".app-id = "com.mitchellh.ghostty"; run = "move-node-to-workspace C"; }
        
        # Browsers
        { "if".app-id = "com.google.Chrome"; run = "move-node-to-workspace B"; }
        { "if".app-id = "org.mozilla.firefox"; run = "move-node-to-workspace B"; }
        { "if".app-id = "com.apple.Safari"; run = "move-node-to-workspace B"; }
        { "if".app-id = "com.microsoft.edgemac"; run = "move-node-to-workspace B"; }
        { "if".app-id = "com.brave.Browser"; run = "move-node-to-workspace B"; }

        # Document/Finder
        { "if".app-id = "com.apple.finder"; run = "move-node-to-workspace D"; }

        # Chat
        { "if".app-id = "com.tinyspeck.slackmacgap"; run = "move-node-to-workspace W"; }
        { "if".app-id = "com.hnc.Discord"; run = "move-node-to-workspace W"; }

        # Reading
        { "if".app-id = "com.apple.Preview"; run = "move-node-to-workspace R"; }
        { "if".app-id = "com.apple.iBooksX"; run = "move-node-to-workspace R"; }
        { "if".app-id = "info.sioyek.sioyek"; run = "move-node-to-workspace R"; }

        # Notes
        { "if".app-id = "notion.id"; run = "move-node-to-workspace N"; }
        { "if".app-id = "com.apple.Notes"; run = "move-node-to-workspace N"; }
        { "if".app-id = "md.obsidian"; run = "move-node-to-workspace N"; }

        # Tools
        { "if".app-id = "com.googlecode.iterm2"; run = "move-node-to-workspace S"; }
        
        # Media/VM
        { "if".app-id = "com.blackmagic-design.DaVinciResolveLite"; run = "move-node-to-workspace V"; }
        { "if".app-id = "com.obsproject.obs-studio"; run = "move-node-to-workspace V"; }
        { "if".app-id = "com.vmware.fusion"; run = "move-node-to-workspace V"; }

        # Special Cases
        { 
          "if".app-id = "org.qutebrowser.qutebrowser"; 
          run = ["layout tiling" "move-node-to-workspace B"]; 
        }
      ];
    };
  };
}
