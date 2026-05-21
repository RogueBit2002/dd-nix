{ ... }: {
	perSystem = { config, pkgs, lib, ... }: {

		packages.impala = pkgs.callPackage 
			({ impala, ... }: let
				desktop-file = pkgs.writeTextFile {
            		name = "impala-desktop";
            		destination = "/share/applications/impala.desktop";
           			text = ''
              			[Desktop Entry]
              			Name=Impala
              			Comment=Wifi TUI for iwd
              			Terminal=true
              			TryExec=${lib.getExe impala}
              			Exec=${lib.getExe impala}
              			Type=Application
              			Categories=Utility;System;ConsoleOnly
              			Keywords=Manager;Networking;Wifi
            		'';
          		};
			in pkgs.symlinkJoin {
				name = impala.name;
				paths = [ impala desktop-file ];
        	}) { };
    };
}
