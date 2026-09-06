{ lib, ... }:
let
  ssh-keys = import ../../nix/ssh-keys.nix;
in
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
        gra = "log --pretty=format:'\"%Cgreen%h %Creset%cd %C(bold blue)[%cn] %Creset%s%C(yellow)%d%C(reset)\"' --graph --date=relative --decorate --all";
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
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
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
        condition = "gitdir:/work/";
        path = "/work/.gitconfig";
      }
    ];

    # SSH signing: ssh-keygen reads the key file directly, so there is no
    # agent to restart and no passphrase cache to flush. Unlike gpg, this
    # works from agent tools (claude, codex, pi) that have no usable tty.
    signing = {
      key = "~/.ssh/id_ed25519";
      signByDefault = true;
      format = "ssh";
    };
  };

  # Lets `git log --show-signature` verify locally; the forges keep their own
  # copy of the keys. This is the trust list rather than the signing key, so it
  # holds every host's key and is identical everywhere - a commit signed on one
  # host has to verify on all the others.
  #
  # The principal is the "*" pattern rather than an address: some hosts sign
  # under a work identity that has no business being in a public repository.
  # Every key listed here is mine, so the only thing given up is catching one
  # of my own keys signing as one of my own other identities.
  home.file.".config/git/allowed_signers".text = lib.strings.concatMapStrings (
    key: "* ${key}\n"
  ) ssh-keys;
}
