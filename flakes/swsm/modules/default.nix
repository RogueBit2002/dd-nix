{ inputs, ... }: {
	perSystem = { config, pkgs, lib, system, ... }: {
		apps.default = { type = "app"; program = lib.getExe config.packages.default; };
		packages.default = pkgs.writeShellScriptBin "swsm" ''
echo "g"
systemctl --user is-active graphical-session.target --quiet || false
graphical_nested=$?

echo "w"
systemctl --user is-active wayland-session@*.target --quiet || false
wayland_nested=$?

echo "c"
if [ "$graphical_nested" -ne 0 ]; then
	echo "Starting graphical-session-pre.target"
fi

echo "Starting compositor"

if [ "$graphical_nested" -ne 0 ]; then
	echo "Starting graphical-session.target"
fi

if [ "$wayland_nested" -ne 0 ]; then
	echo "Starting wayland-session@???.target"	
fi

'';	

		packages.swsm = config.packages.default;
	};
}
