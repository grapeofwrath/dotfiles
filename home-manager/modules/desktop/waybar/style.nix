{campfire, ...}: {
  programs.waybar = {
    style = ''
      @define-color main-br       ${campfire.subtle};
      @define-color main-bg       ${campfire.base};
      @define-color main-fg       ${campfire.text};
      @define-color accent        ${campfire.text};
      @define-color hover-bg      ${campfire.base};
      @define-color hover-fg      alpha(${campfire.text}, 0.75);
      @define-color outline       ${campfire.base};

      @define-color workspaces    shade(${campfire.surface}, 0.75);
      @define-color ip            shade(${campfire.surface}, 0.75);
      @define-color memory        shade(${campfire.overlay}, 0.75);
      @define-color cpu           shade(${campfire.overlay}, 0.75);
      @define-color time          shade(${campfire.muted}, 0.75);
      @define-color date          shade(${campfire.muted}, 0.75);
      @define-color tray          shade(${campfire.surface}, 0.75);
      @define-color wireplumber   shade(${campfire.surface}, 0.75);
      @define-color backlight     shade(${campfire.overlay}, 0.75);
      @define-color battery       shade(${campfire.muted}, 0.75);

      @define-color warning       ${campfire.ember};
      @define-color critical      ${campfire.dawn};
      @define-color charging      ${campfire.fern};

      * {
        font-family: "Jetbrains Mono Nerd Font";
        font-weight: bold;
        font-size: 16px;
        color: @main-fg;
      }

      /* workspaces */

      #custom-left_div.1,
      #custom-right_div.1 {
        color: @workspaces;
      }
      #workspaces {
        padding: 0 1px;
        background-color: @workspaces;
      }
      button {
        border-radius: 16px;
        padding: 0 10px;
      }
      button:hover {
        background-color: @hover-bg;
        color: @hover-fg;
      }
      button.active label {
        font-size: 23px;
        color: @accent;
      }

      /* window and window count */

      #window {
        margin-left: 12px;
      }
      #window label {
        font-weight: normal;
      }
      #windowcount {
        margin-right: 12px;
      }
      #windowcount label {
        color: @hover-fg;
      }

      /* ip */

      #custom-left_div.2 {
        color: @ip;
      }
      #network.ip {
        background-color: @ip;
      }

      /* memory */

      #custom-left_div.3 {
        background-color: @ip;
        color: @memory;
      }
      #memory {
        background-color: @memory;
      }

      /* cpu */

      #custom-left_div.4 {
        background-color: @cpu;
        color: @time;
      }
      #cpu {
        background-color: @cpu;
      }
      #custom-left_inv.1 {
        color: @time;
      }

      /* distro */

      #custom-left_div.5,
      #custom-right_div.2 {
        color: @accent;
      }
      #custom-distro {
        padding: 0 15px 0 5px;
        font-size: 23px;
        background-color: @accent;
        color: @main-bg;
      }

      /* idle inhibitor and time */

      #custom-right_inv.1 {
        color: @time;
      }
      #idle_inhibitor {
        background-color: @tray;
      }
      #clock.time {
        padding-right: 6px;
        background-color: @time;
      }
      #custom-right_div.3 {
        background-color: @memory;
        color: @date;
      }

      /* date */

      #clock.date {
        padding-left: 6px;
        background-color: @date;
      }
      #custom-right_div.4 {
        background-color: @tray;
        color: @memory;
      }

      /* tray */

      #network {
        background-color: @tray;
        padding: 0 6px 0 4px;
      }
      #bluetooth {
        background-color: @tray;
        padding: 0 5px;
      }
      #custom-right_div.5 {
        color: @tray;
      }

      /* mpris */

      #mpris {
        padding: 0 12px;
        font-weight: normal;
      }

      /* group-wireplumber */

      #custom-left_div.6 {
        color: @wireplumber;
      }
      #wireplumber {
        background-color: @wireplumber;
      }

      /* backlight */

      #custom-left_div.7 {
        background-color: @wireplumber;
        color: @backlight;
      }
      #backlight {
        background-color: @backlight;
      }

      /* battery */

      #custom-left_div.8 {
        background-color: @backlight;
        color: @battery;
      }
      #battery {
        background-color: @battery;
      }
      #custom-left_inv.2 {
        color: @battery;
      }

      /*---------------------
        general styling
        ---------------------*/

      #custom-spacer {
        background-color: @main-bg;
      }

      #custom-theme_switcher:hover,
      #idle_inhibitor:hover,
      #clock.date:hover,
      #network:hover,
      #bluetooth:hover,
      #custom-system_update:hover,
      #mpris:hover,
      #wireplumber:hover {
        color: @hover-fg;
      }

      .warning { color: @warning; }
      .critical { color: @critical; }
      .charging { color: @charging; }
      .muted { color: @hover-fg; }

      #custom-left_div,
      #custom-left_inv,
      #custom-right_div,
      #custom-right_inv {
        font-size: 26px;
      }

      /* outline */
      window#waybar {
        background-color: @outline;
      }

      /* background */
      window#waybar > box {
        margin: 0px 0px 4px 0px;
        background-color: @main-bg;
      }

      tooltip {
        border: 2px solid @main-br;
        border-radius: 10px;
        background-color: @main-bg;
      }
      tooltip label {
        margin: 2px 4px;
        font-weight: normal;
      }
      tooltip decoration {
        border: none;
        background-color: transparent;
      }
    '';
  };
}
