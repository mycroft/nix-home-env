{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
let
  inherit (specialArgs.skillSources)
    mycroft-skills
    gh-stack
    superpowers
    mattpocock-skills
    ;

  # Skill name -> skill directory. Repositories are pinned in flake.lock, so `nix flake update`
  # updates them; a skill shipped by a package comes from that package, matching its version.
  skills = {
    gh-stack = "${gh-stack}/skills/gh-stack";
    hunk-review = "${pkgs.hunk}/share/skills/hunk/hunk-review";
    test-driven-development = "${superpowers}/skills/test-driven-development";
    writing-skills = "${superpowers}/skills/writing-skills";

    teach = "${mattpocock-skills}/skills/productivity/teach";
    # grill-me and grill-with-docs only call grilling (and domain-modeling).
    grill-me = "${mattpocock-skills}/skills/productivity/grill-me";
    grill-with-docs = "${mattpocock-skills}/skills/engineering/grill-with-docs";
    grilling = "${mattpocock-skills}/skills/productivity/grilling";
    domain-modeling = "${mattpocock-skills}/skills/engineering/domain-modeling";
  }
  // lib.genAttrs (
    [
      "brutally-honest"
      "coding-with-restraint"
      "commit"
      "editing-skills"
      "review"
    ]
    ++ lib.optionals (lib.elem specialArgs.hostname serviceHosts) serviceSkills
  ) (name: "${mycroft-skills}/skills/${name}");

  # Self-hosted services; their scripts read a token from `pass mcp/<name>`.
  serviceSkills = [
    "gitea"
    "grafana"
    "outline"
  ];
  serviceHosts = [
    "glitter"
    "nee"
  ];

  # Codex, opencode, pi and maki read ~/.agents/skills; Claude Code only reads its own directory.
  skillDirs = [
    ".agents/skills"
    ".claude/skills"
  ];

  # Claude Code plugins (skills plus hooks): a plugin directory in ~/.claude/skills loads as a
  # personal plugin. worktrunk's hooks run `wt`, so the plugin comes from the installed package.
  claudePlugins = {
    worktrunk = "${config.programs.worktrunk.package.src}/plugins/worktrunk";
  };

  # Skills that Claude Code already gets from a plugin above, for the other agents only.
  agentsOnlySkills = {
    worktrunk = "${config.programs.worktrunk.package}/share/skills/worktrunk/worktrunk";
  };

  # Home Manager links a missing source without complaint. Fail the build instead, e.g. when a
  # skill is renamed or removed upstream.
  checked =
    marker: name: src:
    pkgs.runCommandLocal "agent-skill-${name}" { } ''
      if [ ! -f ${src}/${marker} ]; then
        echo "agent skill ${name}: no ${marker} in ${src}" >&2
        exit 1
      fi
      ln -s ${src} $out
    '';

  link =
    dir: marker:
    lib.mapAttrs' (name: src: lib.nameValuePair "${dir}/${name}" { source = checked marker name src; });
in
{
  home.file =
    lib.mergeAttrsList (map (dir: link dir "SKILL.md" skills) skillDirs)
    // link ".claude/skills" ".claude-plugin/plugin.json" claudePlugins
    // link ".agents/skills" "SKILL.md" agentsOnlySkills;
}
