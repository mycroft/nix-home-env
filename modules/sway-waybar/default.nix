{ specialArgs, ... }:
let
  hostname = specialArgs.hostname or "default";

  # Host specific sway bits (outputs, wallpaper, scale, ...). Falls back to
  # files/sway/hosts/default.conf when the host has no dedicated file.
  hostFile = ../../files/sway/hosts + "/${hostname}.conf";
  hostConfig = if builtins.pathExists hostFile then hostFile else ../../files/sway/hosts/default.conf;

  # A host may override only the Waybar settings that differ from the shared
  # configuration by including ~/.config/waybar/common.jsonc.
  waybarHostFile = ../../files/waybar/hosts + "/${hostname}.jsonc";
  waybarConfig =
    if builtins.pathExists waybarHostFile then waybarHostFile else ../../files/waybar/config.jsonc;
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
    "waybar/config".source = waybarConfig;
    "waybar/common.jsonc".source = ../../files/waybar/config.jsonc;
    "waybar/style.css".source = ../../files/waybar/style.css;
  };
}
