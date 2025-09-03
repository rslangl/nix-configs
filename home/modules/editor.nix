{ config, ... }:

{
    #
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      # Plugin manager
      lazy-nvim
      # LSP & completion
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
