

return {
	setup = function(image)
		local nix = require("nix-bridge")
		hl.on("hyprland.start", function()
			hl.exec_cmd(nix.swaybg .. " --color 000000 --image " .. image .. " --mode fit")
		end)

		hl.monitor({
			output = "",
			mode = "preferred",
			position = "auto",
			scale = "auto",
			bitdepth = 10
		})

	end
}
