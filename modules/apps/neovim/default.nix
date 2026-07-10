{ self, inputs, ... }: {
	perSystem = { pkgs, lib, config, ... }: {
		apps.neovim = { type = "app"; program = lib.getExe config.packages.neovim; };

		packages.neovim = (inputs.pancake.lib.make pkgs).override {
			neovim = pkgs.neovim-unwrapped;
			startup-scripts = [ ./config.lua ];
			runtime-paths = with pkgs.vimPlugins; [
				lualine-nvim
				nvim-web-devicons # lualine-nvim
				nvim-lspconfig
				sonokai

				neo-tree-nvim
				plenary-nvim # neo-tree-nvim, nvim-telescope
				nui-nvim # neo-tree-nvim

				render-markdown-nvim
				telescope-nvim
				bufferline-nvim
			];
			native-dependencies = with pkgs; [
				git
				ripgrep # telescope
				lua-language-server
				nil
				zls
			];
		};
	};
}
