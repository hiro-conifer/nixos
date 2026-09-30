{ config, pkgs, ... }:

{
  programs.wofi = {
    enable = true;

    settings = {
      show = "run";
      width = "5%";
      height = "25%";
      prompt = "";
      normal_window = true;
      hide_scroll = true;
      matching = "fuzzy";
      insensitive = true;
      dynamic_lines = true;
    };

    style = ''
      * {
        font-size: 14;
      }

      window {
        background-color: black;
      }

      #input {
        margin: 5px;
        border: none;
        background-color: black;
        color: white;
      }

      #inner-box {
        background-color: black;
      }

      #outer-box {
        margin: 5px;
        padding: 20px;
        background-color: black;
      }

      #text {
        padding: 5px;
        color: white;
      }

      #entry:nth-child(even) {
        background-color: black;
      }

      #entry:selected {
        background-color: #9f0000;
      }
    '';
  };
}

