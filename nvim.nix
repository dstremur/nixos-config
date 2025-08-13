{
  config,
  lib,
  pkgs,
  nixvim,
  ...
}:
{

  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;

    opts = {
      updatetime = 100;

      relativenumber = true;
      number = true;
      termguicolors = true;

      tabstop = 4;
      shiftwidth = 4;

    };

    plugins = {

      web-devicons.enable = true;

      telescope.enable = true;

      treesitter.enable = true;

      luasnip.enable = true;

      lualine.enable = true;

      tiny-inline-diagnostic.enable = true;

	  markdown-preview.enable = true;

      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          clangd.enable = true;
          cmake.enable = true;
          ltex.enable = true;
          quick_lint_js.enable = true;
          tailwindcss.enable = true;
          markdown_oxide.enable = true;
          pylsp.enable = true;
          leanls.enable = true;

        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        autoLoad = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];

        settings.mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };

      };
    };
  };

}
