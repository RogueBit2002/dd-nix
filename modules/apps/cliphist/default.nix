{ ... }: {
	perSystem = { config, pkgs, lib, ... }: {
		packages.cliphist = pkgs.callPackage
			({ cliphist, ... }: pkgs.symlinkJoin {
				name = "cliphist";

				paths = [ cliphist ];
				nativeBuildInputs = [ pkgs.makeWrapper ];
				postBuild = "wrapProgram $out/bin/cliphist --add-flag -config-path --add-flag ${./cliphist.conf}";
				meta.mainProgram = "cliphist";
			}) { };
	};
}
