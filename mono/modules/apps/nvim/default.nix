{ inputs, ... }: {

	perSystem = { config, pkgs, lib, system, ... }: {
		packages.nvim = (inputs.pancake.lib.make pkgs).override {	
			startup-scripts = [ ./init.lua ];
			runtime-paths = with pkgs.vimPlugins; [
				lualine-nvim
				plenary-nvim
				nui-nvim
				nvim-web-devicons
				neo-tree-nvim
				nvim-lspconfig
				sonokai
				telescope-nvim
				render-markdown-nvim
				bufferline-nvim
			];

			native-dependencies = with pkgs; [	
				git
				ripgrep
				lua-language-server
				zls
				nil
				typescript-language-server
			];
		};

		apps.nvim = { type = "app"; program = lib.getExe config.packages.nvim; };
	};
}
