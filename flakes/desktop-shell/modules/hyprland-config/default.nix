{ self, ... }: {
	perSystem = { config, pkgs, lib, ... }: {
		packages.hyprland-config = pkgs.callPackage
			({ terminal, font-family, ... }: let
				
				nix-bridge = pkgs.writeTextFile {
					name = "nix-bridge.lua";
					destination = "/nix-bridge.lua";
					text = ''
return {
	terminal = "${lib.getExe terminal}",
	fuzzel = "${lib.getExe (config.packages.fuzzel.override { inherit terminal; inherit font-family; })}",
	swaybg = "${lib.getExe pkgs.swaybg}",
	wallpaper = "${self + /resources/wallpapers/fw-ascii-hand.png}",
}
'';
				};

			# Fucking lua/hyprland doesn't respect symlinks, so I have to dereference all files
			in pkgs.stdenv.mkDerivation {
				name = "hyprland-config";
				src = pkgs.symlinkJoin { name = "hyprland-config-linked"; paths = [ nix-bridge ./. ]; postBuild = "rm $out/default.nix"; };	
				dontUnpack = true;
				installPhase = ''
					mkdir -p $out
					cp -r -L $src/* $out
				'';
			})
			{ terminal = pkgs.kitty; font-family = null; kanshi-config = null; };
	};
}
