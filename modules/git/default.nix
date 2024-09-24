{ pkgs, specialArgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Patrick Marie";
    userEmail = "pm@mkz.me";
    aliases = {
      br = "branch";
      co = "checkout";
      gra = "gra = log --pretty=format:'\"%Cgreen%h %Creset%cd %C(bold blue)[%cn] %Creset%s%C(yellow)%d%C(reset)\"' --graph --date=relative --decorate --all";
      hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      st = "status";
      staged = "diff --cached";
      last = "rev-parse HEAD";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      core.editor = "nvim";
      github.user = "mycroft";
      help.autocorrect = 1;
      init.defaultBranch = "main";
      color = {
        ui = true;
        pager = true;
      };
      url = {
        "ssh://git@git.mkz.me" = {
          insteadOf = "https://git.mkz.me";
        };
      };
      pull.rebase = true;
      push.autoSetupRemote = true;
      push.default = "tracking";
    };
    signing = {
      key = "A438EE8E0F1C6BAA21EB8EB4BB519E5CD8E7BFA7";
      signByDefault = true;
    };
  };
}
