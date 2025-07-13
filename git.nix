{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.git];
  programs.git.enable = true;
  programs.git.userName = "Rune Langleite"; #userSettings.name;
  programs.git.userEmail = "fjellape1447@protonmail.com"; #userSettings.email;
  programs.git.extraConfig = {
    init.defaultBranch = "main";
    # safe.directory = [ ("/home/" + userSettings.username + "/.dotfiles")
    #                    ("/home/" + userSettings.username + "/.dotfiles/.git") ];
  };
}
