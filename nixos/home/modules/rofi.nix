{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi
  ];

  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
      modi: "drun,run,window,ssh,keys,filebrowser,recursivebrowser,combi";
      combi-modi: "drun,run,window,ssh,filebrowser,recursivebrowser";
      show-icons: true;
      drun-display-format: "{icon}  {name}";
      icon-theme: "Adwaita";
      matching: "normal";
      tokenize: true;
      kb-cancel: "Escape,Control+g";
      kb-accept-entry: "Return,KP_Enter";
    }

    * {
      font: "JetBrainsMono Nerd Font 12";
      g-spacing: 10px;
      g-margin: 0;
      b-color: #222436FF;
      fg-color: #C8D3F5FF;
      fgp-color: #828BB8FF;
      b-radius: 8px;
      g-padding: 8px;
      hl-color: #82AAFFFF;
      hlt-color: #1E2030FF;
      alt-color: #1E2030FF;
      urgent-color: #FF757FFF;
      wbg-color: #222436FF;
      w-border: 2px solid;
      w-border-color: #3B4261FF;
      message-color: #F7768EFF;
      w-padding: 12px;
    }

    listview {
      columns: 1;
      lines: 7;
      fixed-height: true;
      fixed-columns: true;
      cycle: false;
      scrollbar: false;
      border: 0px solid;
    }

    window {
      width: 450px;
      border-radius: @b-radius;
      background-color: @wbg-color;
      border: @w-border;
      border-color: @w-border-color;
      padding: @w-padding;
    }

    prompt {
      text-color: @fg-color;
    }

    inputbar {
      children: ["prompt", "entry"];
      spacing: @g-spacing;
    }

    entry {
      text-color: @fg-color;
      placeholder-color: @fgp-color;
    }

    mainbox {
      spacing: @g-spacing;
      margin: @g-margin;
      padding: @g-padding;
      children: ["inputbar", "listview", "message"];
    }

    element {
      spacing: @g-spacing;
      margin: @g-margin;
      padding: @g-padding;
      border: 0px solid;
      border-radius: @b-radius;
      border-color: @b-color;
      background-color: transparent;
      text-color: @fg-color;
    }

    element normal.normal {
      background-color: transparent;
      text-color: @fg-color;
    }

    element alternate.normal {
      background-color: @alt-color;
      text-color: @fg-color;
    }

    element selected.normal {
      background-color: @hl-color;
      text-color: @hlt-color;
    }

    element selected.active {
      background-color: @hl-color;
      text-color: @hlt-color;
    }

    element selected.urgent {
      background-color: @urgent-color;
      text-color: @hlt-color;
    }

    element-text {
      background-color: transparent;
      text-color: inherit;
    }

    element-icon {
      background-color: transparent;
      size: 1.1em;
    }

    message {
      background-color: @message-color;
      text-color: @fg-color;
      border: 0px solid;
    }

    textbox {
      background-color: transparent;
      text-color: @fg-color;
    }

    error-message {
      background-color: @wbg-color;
      text-color: @fg-color;
      border: 2px solid;
      border-color: @urgent-color;
      padding: @g-padding;
    }
  '';
}
