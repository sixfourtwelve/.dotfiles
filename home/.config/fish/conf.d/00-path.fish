# PATH and toolchain locations.
#
# fish_add_path is idempotent — re-sourcing this file will not stack up
# duplicate entries the way a bare `set -gx PATH` does.

fish_add_path --prepend /opt/homebrew/opt/llvm/bin
fish_add_path --prepend /opt/homebrew/opt/make/libexec/gnubin
fish_add_path --prepend "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
fish_add_path --prepend $HOME/.local/bin

# axmol — universal so a fresh machine gets it even though fish_variables
# is machine-local and never tracked.
set -Ux AX_ROOT $HOME/Developer/axmol
fish_add_path $AX_ROOT/tools/cmdline

set -gx VCPKG_ROOT $HOME/vcpkg
fish_add_path --prepend $VCPKG_ROOT

set -gx VULKAN_SDK "$HOME/VulkanSDK/1.4.350.1/macOS"
fish_add_path --prepend $VULKAN_SDK/bin

fish_add_path $HOME/.nimble/bin
