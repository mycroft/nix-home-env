{ ... }:
{
  programs.git = {
    enable = true;
    lfs = {
      enable = true;
    };
    settings = {
      alias = {
        br = "branch";
        co = "checkout";
        cm = "commit";
        gra = "gra = log --pretty=format:'\"%Cgreen%h %Creset%cd %C(bold blue)[%cn] %Creset%s%C(yellow)%d%C(reset)\"' --graph --date=relative --decorate --all";
        hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        st = "status";
        sw = "switch";
        staged = "diff --cached";
        last = "rev-parse HEAD";
      };
      branch.autosetuprebase = "always";
      color = {
        ui = true;
        pager = true;
      };
      commit = {
        gpgSign = true;
        verbose = true;
      };
      core = {
        editor = "nvim";
        excludesfiles = "~/.gitignore";
        pager = "delta";
      };
      delta = {
        navigate = true;
        dark = true;
        theme = "DarkNeon";
        line-numbers = false;
        side-by-side = false;
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      github.user = "mycroft";
      help.autocorrect = 1;
      init.defaultBranch = "main";
      interactive = {
        diffFilter = "delta --color-only";
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      pull.rebase = true;
      push = {
        autoSetupRemote = true;
        default = "simple";
        followTags = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      ui.auto = true;
      url = {
        "ssh://git@git.mkz.me" = {
          insteadOf = "https://git.mkz.me";
        };
        "ssh://git@gitlab.com" = {
          insteadOf = "https://gitlab.com";
        };
      };
      user = {
        name = "Patrick MARIE";
        email = "pm@mkz.me";
      };
    };
    ignores = [
      "*~"
      "*.swp"
      "target/"
      "dist/"
      "__pycache__/"
    ];
    includes = [
      {
        condition = "gitdir:~/work/";
        path = "~/work/.gitconfig";
      }
    ];

    signing = {
      key = "A438EE8E0F1C6BAA21EB8EB4BB519E5CD8E7BFA7";
      signByDefault = true;
      format = "openpgp";
    };
  };
}
