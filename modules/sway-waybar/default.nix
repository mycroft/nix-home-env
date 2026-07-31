{ ... }:
{
  xdg.configFile = {
    "sway" = {
      source = ../../files/sway;
      recursive = true;
    };
    "waybar" = {
      source = ../../files/waybar;
      recursive = true;
    };
  };
}
