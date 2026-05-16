

return {
	setup = function(image)
		local nix = require("nix-bridge")

		local wp_cmd = nix.swaybg .. " --color 000000 --image " .. image .. " --mode fit"
		hl.on("hyprland.start", function()
			hl.exec_cmd(wp_cmd)
		end)

		--[[hl.on("monitor.layout_changed", function()
			hl.exec_cmd("pkill swaybg")
			hl.exec_cmd(wp_cmd)
		end)]]

		hl.monitor({
			output = "",
			mode = "preferred",
			position = "auto",
			scale = "auto",
			bitdepth = 10
		})

	end
}
