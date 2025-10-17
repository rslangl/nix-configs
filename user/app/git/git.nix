{
  userSettings,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [git];

  programs.git = {
    enable = true;
    userName = userSettings.githubUsername;
    userEmail = userSettings.githubEmail;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
