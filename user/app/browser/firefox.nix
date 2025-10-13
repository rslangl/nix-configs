_: {
  programs.firefox = {
    enable = true;
    policies = {
      DefaultDownloadDirectory = "$HOME/tmp";
    };
    profiles = {
      default = {
        id = 0;
        name = "default";
        bookmarks = {
          force = true;
          settings = [
            {
              name = "searx";
              tags = ["search" "searx"];
              keyword = "searx";
              url = "https://metasearx.com";
            }
            {
              name = "Nix";
              toolbar = true;
              bookmarks = [
                {
                  name = "wiki";
                  tags = ["wiki" "nix"];
                  url = "https://wiki.nixos.org/";
                }
                {
                  name = "packages";
                  tags = ["packages" "nix"];
                  url = "https://search.nixos.org/packages";
                }
              ];
            }
          ];
        };
        # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        #   ublock-origin
        #   privacy-badger
        #   decentraleyes
        #   clearurls
        #   disconnect
        #   darkreader
        #   cookie-autodelete
        #   vimium
        # ];
        search = {
          default = "ddg";
        };
      };
    };
  };
}
