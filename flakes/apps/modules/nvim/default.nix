{ inputs, ... }: {
	perSystem = { pkgs, system, ... }: {
		packages.nvim = inputs.pancake.makeNeovimPackage { 
					inherit pkgs;
					luaConfig = ./init.lua;
					label = "lx";
					plugins = with pkgs; [
						vimPlugins.lualine-nvim
						vimPlugins.plenary-nvim
						vimPlugins.nui-nvim
						vimPlugins.nvim-web-devicons
						vimPlugins.neo-tree-nvim
						vimPlugins.nvim-lspconfig
						vimPlugins.sonokai
						vimPlugins.everforest
						vimPlugins.telescope-nvim
						vimPlugins.render-markdown-nvim	
						vimPlugins.vscode-nvim
						vimPlugins.bufferline-nvim
					] ++ [
						# (builtins.fetchGit { url = "https://https://github.com/kubemancer/firewatch.nvim"; rev = "a7a4a32cb1af942c12f69e41100c9298b5dd12ac";})
					];
					nativeDependencies = with pkgs; [ 
						# LSPs
						typescript-language-server
						lua-language-server
						zls
						nil
						tofu-ls
						ripgrep
					];
				};
	};
}
