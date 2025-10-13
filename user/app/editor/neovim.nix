{pkgs, ...}: {
  home.packages = with pkgs; [
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
    rustfmt
    clippy

    # Go
    go
    gopls
    gotools

    # Java
    # vimPlugins.nvim-jdtls
    # java-language-server
    jdk17
    maven
    gradle
    jdt-language-server
    google-java-format
    checkstyle

    # Scala
    coursier

    # Kotlin
    kotlin-language-server

    # Shell
    bash-language-server
    yaml-language-server
    shellcheck
    shfmt

    # Terraform
    terraform
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
    statix

    # Python
    isort
    black

    # JS
    nodejs_20
    prettierd

    # Android
    android-tools
    android-udev-rules

    # Docker
    dockerfile-language-server
    docker-compose-language-service
  ];

  # home.file.".config/nvim".source = pkgs.fetchFromGitHub {
  #   owner = "rslangl";
  #   repo = "nvim";
  #   rev = "2bd4df3a23b4bbfc1194c7c43379b5668899d93f";
  #   sha256 = "sha256-anKSIGB115FSEgACy7BfUAcntNcFqAx80LOivDZTzLI=";
  # };

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

      # Debugging
      nvim-dap

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
