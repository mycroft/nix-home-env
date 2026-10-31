# agent-skills

Skills linked by `default.nix`. Update them with `nix flake update`, add one by extending the lists
there. See the main README for the workflow.

## Skills

Linked into `~/.agents/skills` (Codex, opencode, pi, maki) and `~/.claude/skills` (Claude Code).

| Skill | What it does | Source |
|---|---|---|
| brutally-honest | Raw, unsoftened feedback on a decision, plan or piece of work, when explicitly asked | `mycroft-skills` |
| coding-with-restraint | Keeps code changes to what was asked: no extra features, abstractions or adjacent edits, and a check before calling it done | `mycroft-skills` |
| commit | Writes commit messages and records work in git | `mycroft-skills` |
| editing-skills | Changing or fixing an existing skill, including one that failed to trigger | `mycroft-skills` |
| review | Reviewing code, a diff or a pull request before approving or merging | `mycroft-skills` |
| gh-stack | Stacked branches and pull requests with the `gh stack` extension | `gh-stack` |
| test-driven-development | Write the failing test first, for any feature or bug fix | `superpowers` |
| writing-skills | Creating and testing skills, applying TDD to documentation | `superpowers` |
| gitea | Repositories, issues, pull requests and Actions runs on git.mkz.me (glitter and nee only) | `mycroft-skills` |
| grafana | Metrics, logs, alerts and dashboards on grafana.services.mkz.me (glitter and nee only) | `mycroft-skills` |
| outline | Reading and writing the Outline wiki at outline.iop.cx (glitter and nee only) | `mycroft-skills` |
| teach | `/teach`: multi-session tutoring on a topic, keeping lessons and learning records in the current directory | `mattpocock-skills` |
| grill-me | `/grill-me`: relentless interview to sharpen a plan or design (runs grilling) | `mattpocock-skills` |
| grill-with-docs | `/grill-with-docs`: the same interview, writing ADRs and a glossary as it goes (runs grilling and domain-modeling) | `mattpocock-skills` |
| grilling | The interview itself, asked in rounds of numbered questions with recommended answers | `mattpocock-skills` |
| domain-modeling | Sharpening a project's domain model: glossary terms and ADRs | `mattpocock-skills` |
| hunk-review | Driving a live Hunk diff review session: navigation, inline comments, highlights | `pkgs.hunk` |

## Claude Code plugins

Linked into `~/.claude/skills` only, where Claude Code loads them as personal plugins.

| Plugin | What it does | Source |
|---|---|---|
| worktrunk | Skills `worktrunk` (configuring the `wt` CLI, its hooks and worktree paths) and `wt-switch-create` (start a session in a new worktree); hooks that route Claude's worktrees through `wt` and show 🤖/💬 activity in `wt list` | `programs.worktrunk.package` source |

## Other agents only

Linked into `~/.agents/skills` only, since Claude Code already gets them from a plugin above.

| Skill | What it does | Source |
|---|---|---|
| worktrunk | Configuring the `wt` CLI, its hooks and worktree paths (no hooks outside Claude Code) | `programs.worktrunk.package` |

Sources are flake inputs (`mycroft-skills`, `gh-stack`, `superpowers`, `mattpocock-skills`)
unless they name a package, in which case the skill follows the installed version of that package.
