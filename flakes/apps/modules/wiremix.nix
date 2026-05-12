{ ... }: {
	perSystem = { config, pkgs, lib, ... }: {
		packages.wiremix = pkgs.callPackage
			({ wiremix, ... }: pkgs.symlinkJoin {
				name = "wiremix";

				paths = [ wiremix (config.packages.wiremix-desktop.override { inherit wiremix; }) ];
			})
			{ };
		packages.wiremix-desktop = pkgs.callPackage 
			({ wiremix, ... }: pkgs.writeTextFile {
			name = "wiremix-desktop";
			text = ''
[Desktop Entry]
Name=Wiremix
Comment=Terminal audio mixer
Terminal=true
TryExec=${lib.getExe wiremix}
Exec=${lib.getExe wiremix}
Type=Application
Categories=Utility;System;ConsoleOnly
Keywords=Manager;Audio
'';
			destination = "/share/applications/wiremix.desktop";
		}) { };
	};
}
