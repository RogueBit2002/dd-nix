{ self, inputs, ... }: {
	perSystem = { config, pkgs, lib, system, ... }: {
		packages.default = config.packages.mtess;
		packages.mtess = pkgs.callPackage
			({
				label ? null,
				terminal ? null,
				launcher ? null,
				clipboard ? null,
				font-family ? null,
				hooks ? [],
				uwsm,
				...}: let
				name = "mtess${if label != null then ":${label}" else ""}";

				/*scopify = pkgs.writeShellApplication {
					name = "mtess-scopify";

					text = ''
name=$(systemd-escape "${name}-"$MTESS_PID".scope")
if ! systemctl --user --quiet is-active graphical-session.target && ! systemctl --user --quiet is-active graphical-session-pre.target
then
	busctl call --user org.freedesktop.systemd1 /org/freedesktop/systemd1 \
    	org.freedesktop.systemd1.Manager StartTransientUnit 'ssa(sv)a(sa(sv))' \
		"$name" fail 1 PIDs au 1 "$MTESS_PID" 0
else
	echo "In a session"
fi

#systemd-run --scope --user --quiet --property=Before=graphical-session.target --property=BindsTo=graphical-session.target --property=Wants=graphical-session-pre.target --property=After=graphical-session-pre.target -- hyprland
'';
				};*/
				hyprland-config = let
					nix-bridge = pkgs.writeTextFile {
						name = "nix.lua";
						destination = "/nix.lua";
						text = let
							opt-bin = bin: if bin == null then "nil" else "\"${if lib.isDerivation bin then lib.getExe bin else builtins.toString bin}\"";
						in ''
hl.on("hyprland.start", function()
	${builtins.foldl' (acc: hook: acc + "\nhl.exec_cmd(\"${lib.strings.escape ["\"" "\\" ] hook}\")") "" hooks}
end)

return {
	terminal = ${opt-bin terminal},
	launcher = ${opt-bin launcher},
	clipboard = ${opt-bin clipboard},
}
'';
					};

				in pkgs.stdenv.mkDerivation {
					name = "hyprland-config";
					src = pkgs.symlinkJoin { name = "hyprland-config-linked"; paths = [ nix-bridge ./hyprland-config ]; };	
					dontUnpack = true;
					installPhase = ''
						mkdir -p $out
						cp -r -L $src/* $out
					'';
				};


				hyprland = inputs.hyprland.packages.${system}.hyprland.override { enableXWayland = true; };

				binary = pkgs.writeShellApplication {
					inherit name;
					runtimeInputs = [
						hyprland
						pkgs.xwayland
						uwsm
					];
					text =''
#if ! systemctl --user --quiet is-active graphical-session.target && ! systemctl --user --quiet is-active graphical-session-pre.target
#then
#	exec systemd-run --scope --user --quiet \
#		--property=Before=graphical-session.target \
#		--property=BindsTo=graphical-session.target \
#		--property=Wants=graphical-session-pre.target \
#		--property=After=graphical-session-pre.target \
#		-- ${lib.getExe' hyprland "start-hyprland"} -- --config ${hyprland-config}/hyprland.lua 
#fi

#exec systemd-run --scope --user --quiet -- ${lib.getExe' hyprland "start-hyprland"} -- --config ${hyprland-config}/hyprland.lua 

exec uwsm start -e -D MTess:Hyprland -- ${lib.getExe' hyprland "start-hyprland"} -- --config ${hyprland-config}/hyprland.lua

'';
				};
			in pkgs.symlinkJoin {
				inherit name;
				paths = [ binary ];
				postBuild = ''
mkdir -p $out/share/wayland-sessions
cat > $out/share/wayland-sessions/${name}.desktop <<EOF
[Desktop Entry]
Name=MTess${if label != null then " - ${label}" else ""} (Hyprland + UWSM)
Comment=Hyprland based tui desktop environment
Exec=$out/bin/${name}
Type=Application
DesktopNames=MTess;Hyprland
Keywords=tiling;wayland;compositor;
EOF
				'';
			}) {
				label = null;
				terminal = pkgs.foot;
				launcher = pkgs.fuzzel;
				clipboard = null;
				font-family = null;
				hooks = [ ];
			};
	};
}
