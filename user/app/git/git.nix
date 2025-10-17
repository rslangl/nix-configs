{
  userSettings,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [git];

  programs.git = {
    enable = true;
    userName = userSettings.gitUsername;
    userEmail = userSettings.gitEmail;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
