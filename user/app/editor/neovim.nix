{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    clang-tools
    vimPlugins.nvim-jdtls

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
    lurarocks
    stylua

    # Nix
    alejandra

    # JS
    nodejs_20

    # Android
    java-language-server
    kotlin-language-server

    # Docker
    dockerfile-language-server-nodejs
    docker-compose-language-service
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
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
