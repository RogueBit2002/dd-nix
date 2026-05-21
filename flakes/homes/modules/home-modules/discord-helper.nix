{ ... }: {
	flake.homeModules.discord-helper = { config, pkgs, lib, ... }: {
		config = lib.mkIf config.programs.discord.enable {
			
			systemd.user.services.discord = {
				Unit = {
					Description = "Discord";
					BindsTo = [ "graphical-session.target" ];
					After = [ "graphical-session.target" ];
				};

				Service = {
					Type = "simple";
					ExecStart = "${lib.getExe config.programs.discord.package} --start-minimized";
					Restart="on-failure";

					KillSignal = "SIGKILL";
					TimeoutStopSec = 0;
				};
				Install = {
					WantedBy = [ "graphical-session.target" ];
				};
			};
		};
	};
}
