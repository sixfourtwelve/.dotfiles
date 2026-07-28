# Interactive shell config.
#
# Almost everything now lives in conf.d/, which fish sources automatically
# and in filename order, before this file:
#
#   00-path.fish        PATH and toolchains
#   10-env.fish         environment
#   20-git-aliases.fish git aliases
#   25-svn-aliases.fish svn/cvs aliases
#   secrets.fish        machine-local, untracked
#
# Keep this file for things that must run last, or only when interactive.

set fish_greeting

# Homebrew's OpenSSL is keg-only, so expose its headers and libraries to
# configure scripts and pkg-config (for example, ObjFW's TLS detection).
set -l openssl_prefix /opt/homebrew/opt/openssl@3
if test -d $openssl_prefix
    if not contains -- "-I$openssl_prefix/include" $CPPFLAGS
        set -gx CPPFLAGS "-I$openssl_prefix/include" $CPPFLAGS
    end
    if not contains -- "-L$openssl_prefix/lib" $LDFLAGS
        set -gx LDFLAGS "-L$openssl_prefix/lib" $LDFLAGS
    end
    if not contains -- "$openssl_prefix/lib/pkgconfig" $PKG_CONFIG_PATH
        set -gx PKG_CONFIG_PATH "$openssl_prefix/lib/pkgconfig" $PKG_CONFIG_PATH
    end
end

set -gx VCPKG_ROOT "$HOME/vcpkg"
fish_add_path "$HOME/.local/bin" "$VCPKG_ROOT"

# Was commented out for as long as ~/.config/starship.toml has existed; the
# formula is in packages/bundle now, so the configured prompt actually runs.
starship init fish | source

