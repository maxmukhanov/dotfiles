{ user, ... }:

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
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock = {
      autohide = false;
      orientation = "bottom";
      tilesize = 48;

      persistent-apps = [
        "/System/Applications/Launchpad.app"
        "/System/Applications/Calendar.app"
        "/System/Applications/Notes.app"
        "/System/Applications/System Settings.app"
        "/Applications/Slack.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/WezTerm.app"
        "/Applications/Google Chrome.app"
        "/Applications/ChatGPT.app"
        "/Applications/Wispr Flow.app"
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
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = [
      "herdr"
      "kubectl"
      "kubectx"
      "k9s"
      "awscli"
      "azure-cli"
      "gh"
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
    ];
  };
}
