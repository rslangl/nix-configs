{
  userSettings,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [git];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = userSettings.gitUsername;
        email = userSettings.gitEmail;
      };
    };
  };
}
