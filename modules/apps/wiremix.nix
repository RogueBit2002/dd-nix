{ ... }: {

	perSystem = { pkgs, lib, ... }: {
		packages.wiremix = pkgs.callPackage
			({ wiremix, ... }: let
				desktop = pkgs.writeTextFile {
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
				};
			in pkgs.symlinkJoin {
				name = "wiremix";

				paths = [ wiremix desktop ];
			})
			{ };
	};
}
