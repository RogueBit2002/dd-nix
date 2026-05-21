{ ... }:
{
	perSystem = { config, pkgs, lib, ... }: {

		packages.default = config.packages.radiotui;
		packages.radiotui = pkgs.callPackage 
			({ impala, bluetui, ... }: let
				binary = pkgs.writeShellApplication {
					name = "radiotui";
					runtimeInputs = [ pkgs.gum pkgs.fzf impala bluetui ];

					text = ''
						get-wifi() {
							if command -v iwctl >/dev/null 2>&1; then printf "impala"; return; fi

							return 1
						}

						get-bluetooth() {
							if command -v bluetoothctl >/dev/null 2>&1; then printf "bluetui"; return; fi

							return 1
						}


						get-options() {
							bin=$(get-wifi) && printf 'wifi\t%s\n' "$bin"
    						bin=$(get-bluetooth) && printf 'bluetooth\t%s\n' "$bin"
						}

						binary=
						no_exec=
						for arg in "$@"
						do
							case "$arg" in
								--no-exec)
									no_exec=1
									;;
								--wifi)
									binary=$(get-wifi)
									;;
								--bluetooth)
									binary=$(get-bluetooth)
									;;
							esac
						done

						if [ ! -n "$binary" ]
						then
							binary=$(get-options | fzf --no-input --delimiter='\t' --with-nth=1 --accept-nth=2)
							
						fi

					 	[ ! -n "$no_exec" ] && exec "$binary"
						printf '%s' "$binary"
					'';

				};
				desktop-file = pkgs.writeTextFile {
            		name = "radiotui-desktop";
            		destination = "/share/applications/radiotui.desktop";
           			text = ''
              			[Desktop Entry]
              			Name=Radio TUI
              			Comment=Wifi & bluetooth TUI
              			Terminal=true
              			TryExec=${lib.getExe binary}
              			Exec=${lib.getExe binary}
              			Type=Application
              			Categories=Utility;System;ConsoleOnly
              			Keywords=Manager;Networking;Radio;Wifi;Bluetooth;
            		'';
          };
        in
        pkgs.symlinkJoin {
			name = "radiotui";
			paths = [ binary desktop-file ];
        }) { };
    };
}
