{ user, ... }:

let
  # macOS 26 (Tahoe) dropped Launchpad in favour of the "Apps" launcher;
  # Sequoia and earlier still ship Launchpad.app. Pick whichever exists.
  launcherApp =
    if builtins.pathExists "/System/Applications/Launchpad.app"
    then "/System/Applications/Launchpad.app"
    else "/System/Applications/Apps.app";
in
{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = false;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
      "com.apple.swipescrolldirection" = false;
    };
    dock = {
      autohide = false;
      orientation = "bottom";
      tilesize = 72;

      persistent-apps = [
        launcherApp
        "/System/Applications/Calendar.app"
        "/System/Applications/Notes.app"
        "/System/Applications/System Settings.app"
        "/Applications/Slack.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/WezTerm.app"
        "/Applications/Google Chrome.app"
        "/Applications/ChatGPT.app"
        "/Applications/Wispr Flow.app"
        "/Applications/Telegram.app"
        "/Applications/DBeaver.app"
        "/Applications/Postman.app"
      ];
    };
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };
  nix-homebrew = {
    enable = true;
    inherit user;
  };

  # Trust the p6m-dev + archetect taps BEFORE Homebrew activation runs.
  # nix-darwin runs extraActivation ahead of the homebrew activation step, so
  # writing ~/.homebrew/trust.json here means nix-homebrew's first-run tapping
  # (which honours HOMEBREW_REQUIRE_TAP_TRUST) never prompts/fails on a fresh
  # machine. Doing this via home-manager's home.file loses the race - that
  # activation runs after Homebrew has already tried, and failed, to tap.
  system.activationScripts.extraActivation.text = ''
    mkdir -p /Users/${user}/.homebrew
    cat > /Users/${user}/.homebrew/trust.json <<'EOF'
    {"trustedtaps":["p6m-dev/tap","archetect/tap"]}
    EOF
    chown ${user}:staff /Users/${user}/.homebrew/trust.json
  '';
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    taps = [
      "p6m-dev/tap"
      "archetect/tap"
    ];
    brews = [
      "herdr"
      "kubectl"
      "kubectx"
      "k9s"
      "awscli"
      "azure-cli"
      "gh"
      "helm"
      "Azure/kubelogin/kubelogin"
      "eza"
      "rust"
      "uv"
      "node"
      "gnupg"
      "p6m"
      "archetect"
      "dotnet"
      "mvn"
      "openjdk"
      "pnpm"
    ];
    casks = [
      "wezterm"
      "claude-code"
      "docker-desktop"
      "visual-studio-code"
      "postman"
      "wispr-flow"
      "chatgpt"
      "dbeaver-community"
      "slack"
      "intellij-idea"
      "font-meslo-lg-nerd-font"
      "notion"
      "telegram"
      "rectangle"
    ];
  };
}
