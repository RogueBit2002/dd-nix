{ self, inputs, ... }: {
	perSystem = { config, pkgs, lib, system, ... }: {
		packages.default = config.packages.mtess;
		packages.mtess = pkgs.callPackage
			({ label ? null, terminal, font-family ? null, hooks ? [], ...}: let
				name = "mtess${if label != null then ":${label}" else ""}";

				hyprland-config = let
					nix-bridge = pkgs.writeTextFile {
						name = "nix.lua";
						destination = "/nix.lua";
						text = ''
hl.on("hyprland.start", function()
	${builtins.foldl' (acc: hook: acc + "\nhl.exec_cmd(\"${lib.strings.escape ["\"" "\\" ] hook}\")") "" hooks}
end)

return {
	terminal = "${lib.getExe terminal}",
	fuzzel = "${lib.getExe (config.packages.fuzzel.override { inherit terminal; inherit font-family; })}",
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
						pkgs.uwsm
					];
					text = "uwsm start -e -D MTess:Hyprland -- ${lib.getExe' hyprland "start-hyprland"} -- --config ${hyprland-config}/hyprland.lua";
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
			}) { label = null; terminal = pkgs.foot; font-family = null; hooks = [ ]; };
	};
}
