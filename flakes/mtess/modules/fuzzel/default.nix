{ ... }: { 
	perSystem = { pkgs, lib, ... }: {
		packages.fuzzel = pkgs.callPackage
		({ fuzzel, terminal ? null, font-family ? null, ...}: pkgs.symlinkJoin {
			name = "fuzzel";

			paths = [ fuzzel ];
			nativeBuildInputs = [ pkgs.makeWrapper ];
			postBuild = "wrapProgram $out/bin/fuzzel --add-flag --config --add-flag ${./fuzzel.ini}"
				+ (if font-family != null then " --add-flag --font=${font-family}" else "")
				+ (if terminal != null then " --add-flag --terminal --add-flag \"${lib.getExe terminal} -e {cmd}\"" else "");

			meta.mainProgram = "fuzzel";
		})
		{ font-family = "monospace"; terminal = null; };
	};
}
