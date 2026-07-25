# AGENTS.md

Instructions for coding agents working in this repo. Read this before changing
anything.

## What this repo is

A Stow-managed dotfiles repo. `home/` mirrors `$HOME`; `packages/` declares
what gets installed; `dot` is a bash CLI that is the only supported way to
modify either. It is **public** — assume everything you add will be read by
strangers.

## Rules

**Never hand-edit symlinks in `$HOME`.** Edit the file under `home/` and run
`dot stow`. A file in `$HOME` that is not a symlink into this repo is a bug;
`dot doctor` reports it as "shadowed by a real file".

**To track a new file, move it — do not copy it.** Stow errors when a real file
occupies the target path. `mv ~/.foo home/.foo && dot stow`.

**Never add a credential, token, key, or internal hostname.** `dot secret-scan`
runs standalone and inside `dot doctor`, and is a gate before pushing. It is
pattern-based, so it catches tokens and keys but **not** personal content — a
private URL, an internal hostname, a medical detail. Judge those yourself
before publishing. Machine-specific or sensitive values belong in the untracked
files documented in the README, never in a tracked one.

**Keep `dot` shellcheck-clean.** `shellcheck dot` must pass with no output
before you commit. It is `set -euo pipefail`; be careful with commands whose
non-zero exit is expected — `grep` in particular needs `|| true`.

**Never commit a commercial font.** MonoLisa is paid, licensed to one person,
and this repo is public — adding those `.ttf` files here would publish it. They
live in the private `mono-lisa` repo and `dot fonts` copies them out of the
clone at install time. If asked to "make the fonts install automatically", that
is already done; do not solve it by tracking the files. The same reasoning
applies to any other licensed asset.

**Do not add employer-specific names or internal details.** Use `WORK` as the
placeholder when documentation needs to describe workplace-only configuration.
Keep machine-specific or sensitive values in the untracked files documented in
the README.

## Packages

There are four manifests:

| File | Contents |
|---|---|
| `packages/bundle` | One Brewfile. Lines tagged `# work` at end-of-line are work-only |
| `packages/ollama` | One model tag per line |
| `packages/repos` | `owner/repo [dest]`, cloned over SSH |
| `packages/tools` | `<binary> <shell> <url>`, installed by `curl \| sh` |

Everything in `packages/bundle` installs on every machine except lines tagged
`# work`, which only install with `--work`. The tag is a trailing Ruby
comment, so `brew bundle` itself always sees a valid file regardless of
whether `dot` filters it first — `dot package add <name> ... work` appends
the tag for you; do not hand-edit it in ambiguous positions.

**Casks are allowed as `# work` entries.** Upstream `dmmulroy/.dotfiles`
calls work-only casks an anti-pattern and keeps that file formulae-only; we
diverge on purpose, because Slack is a cask and genuinely work-only.

Prefer `dot package add <name>` over editing a Brewfile by hand — it verifies
the token against Homebrew, works out formula vs cask, inserts it in
alphabetical order, and installs it.

Three cask tokens are not the obvious guess and must not be "corrected":

| App | Token |
|---|---|
| Dia | `thebrowsercompany-dia` |
| Hex | `kitlangton-hex` |
| Tailscale | `tailscale-app` (the GUI; `tailscale` is CLI-only) |

**`packages/tools` is only for tools with no usable formula.** It exists
because `claude` and `pi` ship a `curl | sh` installer as their supported
install path. Anything installable with brew goes in a bundle instead. Entries
are three whitespace-separated fields and the shell must be `sh` or `bash`;
`tools_install` passes the url and shell to `bash -c` as *arguments*, so do not
"simplify" it into an interpolated command string. A tool already on PATH is
never installed over, whatever put it there — `pi` on the current machine is a
global npm package under Homebrew's node prefix, and that counts as installed.

**Executor is not a `packages/tools` entry.** It installs via
`npm install -g executor`, not `curl | sh`, so it does not fit that manifest's
format. It has its own subsystem instead: `cmd_executor` / `executor_install`
/ `executor_status` in `dot`, wired into `init` (after `tools`, since
registering with `claude` needs `claude` on PATH), `update`, `doctor`, and
`retry-failed`. Do not fold it into `packages/tools`.

**Ordering in `dot init` is not arbitrary.** `tools` must stay after `stow` —
those installers write into `~/.claude` and `~/.pi`, which are tracked, and
running them first leaves real files where the symlinks belong, which stow then
refuses to link over. `repos` must stay after `gen-ssh-key` — the manifest is
private repos cloned over SSH, and it cannot succeed before GitHub has the key.
`fonts` must stay after `repos`, because it copies out of that clone. Do not
reorder init steps for tidiness.

**Do not remove `HOMEBREW_CASK_OPTS=--adopt` from `install_bundles`.** Most of
these apps already exist in `/Applications` on a machine that predates this
repo, and without `--adopt` brew aborts with "It seems there is already an App
at ...". Adoption takes the existing app under management in place, with no
redownload.

**Do not put `docker-desktop` in a bundle.** Containers here are `colima` plus
the `docker` CLI formula; the Desktop cask conflicts with both.

## Things that will trip you up

**Never remove `--no-folding` from `cmd_stow`.** It is load-bearing. Without
it Stow links whole directories into the repo whenever the target does not
already exist, and on a fresh machine the agents then write gigabytes of
`projects/`, `plugins/` and session state *inside* this repo. It looks like a
harmless flag and it is not.

**`.gitignore` is inverted for four trees** — `.claude`, `.pi`, `.plannotator`
and `.config/herdr`: ignore everything, then un-ignore each tracked path. Those
directories hold gigabytes of per-machine state next to a few kilobytes worth
keeping. Adding a file under any of them requires a matching `!` line, or git
silently skips it and you will think you committed something you did not.

**Ghostty reads `home/.config/ghostty/config`.** Its macOS default location is
`~/Library/Application Support/com.mitchellh.ghostty/`, and the live config was
moved out of there deliberately so it sits with the rest. Verify changes with
`ghostty +show-config` — it prints the *effective* config, so it will tell you
whether the file you edited is the one being read. There is also a stale draft
at `~/ghostty-shit` on the original machine; it is not tracked and is not the
source of truth.

**Git identity lives in `home/.config/git/config`, not `~/.gitconfig`.** Git
reads both and `~/.gitconfig` wins every single-valued key, so a stray
`~/.gitconfig` silently shadows this repo. There is deliberately none. Note
`git config --global` reads and writes `~/.gitconfig` only — use
`git config --get` (effective config) or `--file` to target a specific file.

**`/usr/local/bin/ollama` is not a second install.** It is a symlink Ollama.app
creates into its own bundle. Deleting it breaks the CLI while the app keeps
running. Adopt the cask instead.

**Commits are signed.** `commit.gpgsign` is true in the tracked config. If you
are committing in an environment with no GPG key, use `--no-gpg-sign`
explicitly rather than turning signing off in the config.

## Before you push

```sh
shellcheck dot        # no output
dot doctor            # green
dot secret-scan       # clean
git status            # clean
```
