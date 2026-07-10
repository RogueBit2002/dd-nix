local Axis = { horizontal = 0, vertical = 1 }

local transform_to_direction = {
	[0] = "right",
	[1] = "down",
	[2] = "right",
	[3] = "down",
	[4] = "right",
	[5] = "down",
	[6] = "right",
	[7] = "down"
}

local transform_to_axis = {

	[0] = Axis.horizontal,
	[1] = Axis.vertical,
	[2] = Axis.horizontal,
	[3] = Axis.vertical,
}

local direction_to_style = {
	["right"] = "slidevert",
	["down"] = "slide",
}

local direction_to_axis = {
	["right"] = Axis.horizontal,
	["down"] = Axis.vertical,
	["left"] = Axis.horizontal,
	["up"] = Axis.vertical
}

local function resize_window(axis, grow)
	local window = hl.get_active_window()

	if window == nil then return end


	if axis == transform_to_axis[window.workspace.monitor.transform] then
		hl.dispatch(hl.dsp.layout("colresize " .. (grow and "+conf" or "-conf")))
	else

		local x,y = 0,0
		local monitor = window.workspace.monitor
		if axis == Axis.horizontal then
			x = monitor.width * 0.2
		else
			y = monitor.height * 0.2
		end

		if not grow then
			x,y = -x,-y
		end

		hl.dispatch(hl.dsp.window.resize({ x=x, y=y, relative = true }))
	end
end

return {
	setup = function(settings)
		local mainMod = settings.modifier

		if settings.animation ~= nil then
			hl.animation({
				leaf = "workspaces",
				enabled = true,
				speed = settings.animation.speed,
				bezier = settings.animation.bezier,
				spring = settings.animation.spring,
				style = "slidevert"
			})
		end

		hl.config({
			general = {
				layout = "scrolling",

				-- Prevents wrapping focus around the screen when at the edge
				no_focus_fallback = true,
				resize_on_border = false
			},

			scrolling = {
				direction = "right"
			},

			binds = {
				window_direction_monitor_fallback = false
				-- Prevents moving focus to another monitor when at the edge
			}
		})

		local input_directions = {
			left = { "H", "left" },
			down = { "J", "down" },
			up = { "K", "up" },
			right = { "L", "right" }
		}

		for dir, keys in pairs(input_directions) do
			for i, key in pairs(keys) do
				-- hl.dsp.layout("focus {dir}") is influenced by scrolling direction (which is bad), so hl.dsp.focus should be used
				hl.bind(string.format("%s + %s", settings.modifier, key), hl.dsp.focus({ direction = dir }))
				hl.bind(string.format("%s + SHIFT + %s", settings.modifier, key), hl.dsp.window.move({ direction = dir }))
				-- hl.bind(string.format("%s + CTRL + %s", settings.modifier, key), hl.dsp.focus({ monitor = dir[1] }))
				-- hl.bind(string.format("%s + CTRL + SHIFT + %s", settings.modifier, key), hl.dsp.window.move({ monitor = dir[1] }))
			end
		end

		for i=1,5 do
			hl.bind(string.format("%s + %d", mainMod, i), hl.dsp.focus({ workspace = string.format("r~%d", i)}))
			hl.bind(string.format("%s + SHIFT + %d", mainMod, i), hl.dsp.window.move({ workspace = string.format("r~%d", i)}))
		end

		hl.bind(mainMod .. " + N", function() resize_window(Axis.horizontal, true) end)
		hl.bind(mainMod .. " + SHIFT + N", function() resize_window(Axis.horizontal, false) end)
		hl.bind(mainMod .. " + M", function() resize_window(Axis.vertical, true) end)
		hl.bind(mainMod .. " + SHIFT + M", function() resize_window(Axis.vertical, false) end)

		hl.bind(mainMod .. " + P", hl.dsp.layout("promote"))
		hl.bind(mainMod .. " + SHIFT + P", function()
			hl.dispatch(hl.dsp.layout("promote"))
			hl.dispatch(hl.dsp.layout("swapcol l"))
		end)

		hl.bind(mainMod .. " + comma", hl.dsp.layout("swapcol l"))
		hl.bind(mainMod .. " + period", hl.dsp.layout("swapcol r"))
		hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

		hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
		hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


		local monitors_state = {}
		hl.on("monitor.layout_changed", function()
			local monitors = hl.get_monitors()

			local changes
			for i,m in pairs(monitors) do
				if monitors_state[m.id] == m.transform then goto write end
				changes = true;
				::write::
				monitors_state[m.id] = m.transform
			end

			if not changes then return end

			for i,m in pairs(monitors) do
				local direction = transform_to_direction[m.transform]
				local rule = { workspace = "m[" .. m.id .. "]", layout_opts = { direction = direction } }

				if settings.animation ~= nil then
					rule.animation = direction_to_style[direction]
				end

				hl.workspace_rule(rule)
			end
		end)

	end
}
