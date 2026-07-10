{ ... }: {
	perSystem = { pkgs, ... }: {
		packages.kitty = pkgs.callPackage ({ font-family ? null, ... }: let

			final-config = pkgs.writeText "kitty.conf" 
				(builtins.readFile ./kitty.conf
				+ (if font-family != null then "\nfont_family family=\"${font-family}\"\nbold_font auto\nitalic_font auto\nbold_italic_font auto\n" else ""));
		in pkgs.symlinkJoin {
			name = "kitty";

			paths = [ pkgs.kitty ];
			nativeBuildInputs = [ pkgs.makeWrapper ];
			postBuild = "wrapProgram $out/bin/kitty --add-flag --config --add-flag ${final-config}";

			meta.mainProgram = "kitty";
		}) { font-family = null; };
	};
}
