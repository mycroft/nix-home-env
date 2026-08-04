{ specialArgs, ... }:
let
  hostname = specialArgs.hostname or "default";

  # Host specific sway bits (outputs, wallpaper, scale, ...). Falls back to
  # files/sway/hosts/default.conf when the host has no dedicated file.
  hostFile = ../../files/sway/hosts + "/${hostname}.conf";
  hostConfig = if builtins.pathExists hostFile then hostFile else ../../files/sway/hosts/default.conf;
in
{
  xdg.configFile = {
    "sway/config" = {
      source = ../../files/sway/config;
    };
    # Included by files/sway/config through `include ~/.config/sway/config.d/*.conf`
    "sway/config.d/host.conf" = {
      source = hostConfig;
    };
    "waybar" = {
      source = ../../files/waybar;
      recursive = true;
    };
  };
}
