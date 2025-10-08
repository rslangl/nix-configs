{pkgs, ...}: {
  home.packages = with pkgs; [
    vimPlugins.nvim-jdtls

    # C/C++
    gcc
    gnumake
    cmake
    autoconf
    automake
    libtool
    clang-tools

    # Rust
    cargo
    rust-analyzer

    # Go
    go
    gopls

    # Shell
    bash-language-server
    yaml-language-server
    shellcheck
    shfmt

    # Terraform
    terraform-ls

    # Ansible
    ansible

    # Lua
    lua-language-server
    luajitPackages.luacheck
    luarocks
    stylua

    # Nix
    alejandra

    # JS
    nodejs_20

    # Android
    java-language-server
    kotlin-language-server
    android-tools
    android-udev-rules

    # Docker
    dockerfile-language-server-nodejs
    docker-compose-language-service
  ];

  # home.sessionVariables = {
  #   EDITOR = "nvim";
  # };
  #
  home.file.".config/nvim".source = builtins.fetchGit {
    url = "https://github.com/rslangl/nvim.git";
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      # Plugin manager
      lazy-nvim

      # LSP and completion
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp_luasnip
      luasnip

      # Formatters & linters
      conform-nvim
      nvim-lint

      # Syntax highlighting
      nvim-treesitter

      # Language-specific
      rustaceanvim
      go-nvim
    ];
  };
}
