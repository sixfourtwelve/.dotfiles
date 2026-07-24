# .dotfiles

macOS (Apple Silicon) config for [@sixfourtwelve](https://github.com/sixfourtwelve),
managed with [GNU Stow](https://www.gnu.org/software/stow/) and a small bash CLI.

Everything under `home/` mirrors `~` and is symlinked into place. Everything
installable is declared in `packages/`. `dot` is the only thing that writes to
either.

```
.dotfiles/
├── dot                  # the CLI
├── home/                # stowed into ~
│   ├── .config/
│   │   ├── fish/        # config.fish + conf.d/
│   │   ├── git/         # personal identity, work split
│   │   └── nvim/
│   ├── .claude/         # settings, statusline, skills
│   ├── .pi/             # settings, agents, skills, extensions
│   ├── .agents/skills/  # shared skill store, symlinked from both agents
│   ├── .vimrc
│   └── .tmux.conf
└── packages/
    ├── bundle           # Brewfile: every machine
    ├── bundle.work      # Brewfile: work machines only
    ├── ollama           # model manifest
    ├── repos            # private repos to clone
    └── tools            # installed by their own `curl | sh`, not brew
```

## Setting up a new machine

### 1. Bootstrap

```sh
xcode-select --install                                    # git; skip if already prompted
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install gh && gh auth login                          # do this FIRST, see below

git clone https://github.com/sixfourtwelve/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./dot init          # --work on a work machine; --dry-run to rehearse
./dot link          # put `dot` on PATH via ~/.local/bin
./dot doctor
```

**Authenticate `gh` before `init`, not after.** `init` generates the SSH and
GPG keys and then immediately tries to clone the private repos in
`packages/repos`. With no authenticated `gh` it cannot upload the keys, so that
clone fails and you finish up in `dot retry-failed`. Authenticate first and the
whole run completes in one pass.

**Clone it — do not download the zip.** The zip has no `.git`, so `dot update`
can never pull. It extracts to a folder starting with `.`, which Finder hides.
And Stow points every symlink at wherever the folder sits, so leaving it in
`~/Downloads` and later clearing that folder breaks your entire shell.

### 2. What init does, and where it stops

Homebrew → bundles → stow → upstream tools → SSH key → GPG key → private repos
→ Ollama and models → fish plugins → tmux plugins → docker compose → login
shell.

Expect roughly six interactive stops: sudo for Homebrew, sudo for a couple of
casks, an SSH passphrase, a GPG passphrase, `y/N` for the ~64 GB model pull,
and `y/N` plus sudo to make fish the login shell. Budget an hour, most of it
the ollama download. Open a new terminal afterwards for fish to take effect.

On a machine that already has years of config, rehearse with
`./dot init --dry-run` first — it prints every command and changes nothing.

### 3. Restore what is deliberately untracked

Nothing warns you these are missing, because the repo does not know about them:

```sh
scp old-mac:~/.config/fish/conf.d/secrets.fish ~/.config/fish/conf.d/
scp -r old-mac:~/.claude/skills/noteday ~/.claude/skills/
```

`secrets.fish` carries machine-local environment that is not published;
without it the shell still works, but anything depending on it will not.
`local_config` regenerates itself via `dot gen-gpg-key`, so it needs nothing.
On a work machine, fill in the real values in
`home/.config/git/work_config`.

## Commands

| | |
|---|---|
| `dot init [flags]` | Full setup |
| `dot update` | Pull, `brew upgrade`, restow, sync models |
| `dot doctor` | Health check; non-zero exit on failure |
| `dot stow` / `unstow` | Manage the symlinks only |
| `dot package add <name> [brew\|cask] [base\|work]` | Add to a bundle and install; kind is auto-detected |
| `dot package remove <name> [base\|work]` | Remove from a bundle (never uninstalls) |
| `dot check-packages` | Installed vs missing, per bundle |
| `dot retry-failed` | Re-run whatever failed during the last `init` |
| `dot gen-ssh-key [--force]` | ed25519 SSH key, agent, `gh ssh-key add` |
| `dot gen-gpg-key` | ed25519 signing key, git config, `gh gpg-key add` |
| `dot ollama list\|pull\|sync` | Model manifest |
| `dot repos list\|clone` | Private repos; `clone` needs SSH working first |
| `dot repos add <owner/repo> [dest]` | Add to the manifest and clone |
| `dot tools list` | `packages/tools` vs what is on PATH |
| `dot tools install [name...]` | Run the upstream installer for anything missing; `--force` reinstalls |
| `dot fonts` | Install fonts from the mono-lisa clone into `~/Library/Fonts` |
| `dot secret-scan` | Scan tracked files for credential-shaped strings |
| `dot completions` | Emit fish completions |
| `dot edit` | Open the repo in `$EDITOR` |

`init` flags: `--skip-ssh`, `--skip-gpg`, `--skip-ollama`, `--skip-casks`,
`--skip-repos`, `--skip-tools`, `--work`, `--dry-run`. `--dry-run` works on any
command, not just `init`.

## Things worth knowing

**Stow runs with `--no-folding`, and that matters.** By default Stow symlinks a
whole *directory* into the repo when the target does not already exist. On a
fresh machine that makes `~/.claude` a link to `home/.claude`, so everything the
app then writes — `projects/`, `plugins/`, session history, gigabytes of it —
lands inside the repo. `--no-folding` creates real directories and symlinks only
files, so `~/.claude`, `~/.pi` and `~/.plannotator` stay real directories with
just their tracked leaves linked. Behaviour is then identical on a fresh machine
and on one with years of existing config. `.gitignore` uses the matching
inverted pattern: ignore everything, un-ignore the tracked paths.

**Move, never copy.** Stow errors when a real file already occupies the place a
symlink belongs. To track a new file, `mv` it into `home/` and re-run
`dot stow`; copying it fails on every file.

**Three files are deliberately untracked**, and a fresh clone works without
them:

| | |
|---|---|
| `home/.config/fish/conf.d/secrets.fish` | Machine-local environment, not for publishing |
| `home/.config/git/local_config` | The GPG signing key id, which is machine-specific |
| `home/.config/fish/fish_variables` | fish universal variables, machine state |

**Signing is on by default.** `commit.gpgsign` and `tag.gpgsign` are set in the
tracked git config, and the fish aliases `gc`/`gca`/`gts` sign too. On a new
machine every commit fails until `dot gen-gpg-key` has run — that is the point,
and `dot doctor` fails loudly while it is outstanding.

**Work identity.** Repos under `~/Code/work/` pick up
`home/.config/git/work_config` via `includeIf`. It ships placeholders; set the
real values locally and they never reach this public repo:

```sh
git config --file ~/.config/git/work_config user.name  "Your Name"
git config --file ~/.config/git/work_config user.email "you@employer.com"
```

`dot doctor` fails if `~/Code/work` exists while the placeholders are still in.

**Casks are adopted, not reinstalled.** If an app is already in
`/Applications`, `brew install --cask` normally aborts. `dot` sets
`HOMEBREW_CASK_OPTS=--adopt` so the existing app is taken under management in
place, with no redownload. The same applies to Ollama.app.

**Private repos are cloned, not submoduled.** `packages/repos` lists
`owner/repo [destination]`, defaulting to `~/Code/<repo>`. They are
private and cloned over SSH, so `dot init` runs this *after* `gen-ssh-key`,
and `dot repos clone` checks that GitHub actually accepts the key before it
starts — otherwise each repo fails with a "Repository not found" that reads
like the repo is missing rather than like the key was never registered.
Already-cloned repos are never touched: no pull, no reset.

**Fonts are two separate things.** JetBrains Mono is ghostty's `font-family`
and comes from the bundle as `font-jetbrains-mono`. The italic and bold-italic
faces are MonoLisa, which is commercial — it lives in the private `mono-lisa`
repo and is never tracked here. Cloning that repo does not install anything,
because macOS only loads fonts from `~/Library/Fonts`; `dot fonts` copies them
across, and `dot init` runs it straight after the repo clone.

**Containers are colima, not Docker Desktop.** `docker` in the bundle is the
CLI only; `colima` provides the VM and runtime. Start it with `colima start`
and docker finds it with no further setup. Do not add the `docker-desktop`
cask — it conflicts.

Homebrew ships compose as a standalone binary, so `docker compose` would not
find it. `dot init` symlinks it into `~/.docker/cli-plugins` rather than
following Homebrew's advice to add `cliPluginsExtraDirs` to
`~/.docker/config.json`, because that file holds registry credentials and is
not something this repo should be editing.

**Two tools do not come from Homebrew.** `claude` and `pi` are installed by
their own upstream script, and `packages/tools` records the binary, the shell
to pipe into, and the URL:

```
claude  bash  https://claude.ai/install.sh
pi      sh    https://pi.dev/install.sh
```

`dot tools install` skips anything already on PATH — however it got there, so
a `pi` installed globally through npm counts and is not installed over. Both
tools self-update, so this is a first-machine step rather than an upgrade path;
`--force` re-runs an installer anyway. `dot init` runs it *after* `stow`, which
matters: both write into `~/.claude` and `~/.pi`, and doing it the other way
round leaves real files where the tracked symlinks belong, which stow then
refuses to link over. Anything with a usable Homebrew formula belongs in
`bundle` instead — this manifest is for tools that have no good one.

**Models are not in git.** `packages/ollama` is a manifest of six tags,
roughly 64 GB on a fresh machine. `dot ollama sync` pulls only what is missing
and asks first. Models you pull by hand are never removed — `dot ollama list`
shows them as untracked.
