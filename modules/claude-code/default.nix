{ config, ... }:
{
  programs.claude-code = {
    enable = true;
    # Claude Code is the self-updating native install in ~/.local/share/claude.
    package = null;
    configDir = "${config.home.homeDirectory}/.claude";
    # Claude Code writes to settings.json itself (/config, /model, plugin installs, permissions).
    # Each switch merges the settings below into it: declared keys win, everything else stays
    # as Claude Code wrote it (model, plugins, marketplaces, the herdr hook, ...). Removing a
    # key here does not remove it from the file.
    mutableSettings = true;
    settings = {
      # Fail instead of opening pinentry in the agent's terminal when the gpg key is not cached.
      env.PASSWORD_STORE_GPG_OPTS = "--pinentry-mode=cancel";
      # Keep session transcripts for ~10 years instead of the 30-day default.
      cleanupPeriodDays = 3650;
      modelSettings.claude-opus-5-5.effortLevel = "xhigh";
      skipWorkflowUsageWarning = true;
      theme = "dark";
      tui = "fullscreen";
    };
  };
}
