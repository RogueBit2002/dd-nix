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
		hl.notification.create({ text = "No support for cross axis scaling yet", duration = 2000 })
	end
end

local function move_workspace(next, window)
	local workspaces = {}
	
	local current_workspace = hl.get_active_workspace()


	-- Normally I'd do hl.get_workspaces(selector) but I have no idea what selector should be and it's not documented anywhere
	-- No matter what value I used it always returns *all* workspaces (even with workspace style monitor selectors)
	local all_workspaces = hl.get_workspaces()

	for i = 1, #(all_workspaces) do
		if all_workspaces[i].monitor.id == current_workspace.monitor.id then table.insert(workspaces, all_workspaces[i]) end
	end


	local index
	for i = 1, #(workspaces) do
		if workspaces[i].id ~= current_workspace.id then goto continue end

		index = i
		break
		::continue::
	end

	if index == nil then return end -- Something went wrong

	local dispatcher = window and hl.dsp.window.move or hl.dsp.focus
	if next then
		if index == #(workspaces) then
			-- Don't create infinite workspaces when moving down, reuse the current empty one
			if current_workspace.windows ~= 0 then
				hl.dispatch(dispatcher({ workspace = "r+1" })) -- Only works for creating a new workspace, shouldn't be used for navigating the layout
				-- hl.dispatch(dispatcher({ workspace = "emptynm" })) -- This should work but is bugged and doesn't stay on monitor
			end
		else
			hl.dispatch(dispatcher({ workspace = workspaces[index + 1].id }))
		end
	else
		if index > 1 then
			hl.dispatch(dispatcher({ workspace = workspaces[index - 1].id }))
		end
	end
	
end

return {
	setup = function(options)
		local mainMod = options.modifier

		if options.animation ~= nil then
			hl.animation({
				leaf = "workspaces",
				enabled = true,
				speed = options.animation.speed,
				bezier = options.animation.bezier,
				spring = options.animation.spring,
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

		local function patch_workspace(workspace)
			local direction = transform_to_direction[workspace.monitor.transform]

			local rule = { workspace = workspace.id, layout_opts = { direction = direction } }

			if options.animation ~= nil then
				rule.animation = direction_to_style[direction]
			end


			hl.notification.create({ text = workspace.id .. ":: " .. rule.animation, duration = 3000 })
			hl.workspace_rule(rule)
		end

		hl.on("workspace.created", patch_workspace)
		hl.on("workspace.active", patch_workspace)
		hl.on("workspace.move_to_monitor", patch_workspace)
		hl.on("window.open_early", function(window) patch_workspace(window.workspace) end)


		hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

		hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
		hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

		hl.bind(mainMod .. " + H", hl.dsp.layout("focus left"))
		hl.bind(mainMod .. " + J", hl.dsp.layout("focus down"))
		hl.bind(mainMod .. " + K", hl.dsp.layout("focus up"))
		hl.bind(mainMod .. " + L", hl.dsp.layout("focus right"))

		hl.bind(mainMod .. " + left", hl.dsp.layout("focus left"))
		hl.bind(mainMod .. " + down", hl.dsp.layout("focus down"))
		hl.bind(mainMod .. " + up", hl.dsp.layout("focus up"))
		hl.bind(mainMod .. " + right", hl.dsp.layout("focus right"))

		hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ direction = "left" }))
		hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ direction = "down" }))
		hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ direction = "up" }))
		hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ direction = "right" }))

		hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "left" }))
		hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "down" }))
		hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "up" }))
		hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))

		--[[hl.bind(mainMod .. " + SHIFT + H", function() move_workspace("left", false) end)
		hl.bind(mainMod .. " + SHIFT + J", function() move_workspace("down", false) end)
		hl.bind(mainMod .. " + SHIFT + K", function() move_workspace("up", false) end)
		hl.bind(mainMod .. " + SHIFT + L", function() move_workspace("right", false) end)

		hl.bind(mainMod .. " + SHIFT + CTRL + H", function() move_workspace("left", true) end)
		hl.bind(mainMod .. " + SHIFT + CTRL + J", function() move_workspace("down", true) end)
		hl.bind(mainMod .. " + SHIFT + CTRL + K", function() move_workspace("up", true) end)
		hl.bind(mainMod .. " + SHIFT + CTRL + L", function() move_workspace("right", true) end)

		hl.bind(mainMod .. " + SHIFT + left", function() move_workspace("left", false) end)
		hl.bind(mainMod .. " + SHIFT + down", function() move_workspace("down", false) end)
		hl.bind(mainMod .. " + SHIFT + up", function() move_workspace("up", false) end)
		hl.bind(mainMod .. " + SHIFT + right", function() move_workspace("right", false) end)

		hl.bind(mainMod .. " + SHIFT + CTRL + left", function() move_workspace("left", true) end)
		hl.bind(mainMod .. " + SHIFT + CTRL + down", function() move_workspace("down", true) end)
		hl.bind(mainMod .. " + SHIFT + CTRL + up", function() move_workspace("up", true) end)
		hl.bind(mainMod .. " + SHIFT + CTRL + right", function() move_workspace("right", true) end)]]

		hl.bind(mainMod .. " + comma", function() move_workspace(false, false) end)
		hl.bind(mainMod .. " + period", function() move_workspace(true, false) end)

		hl.bind(mainMod .. " + CTRL + comma", function() move_workspace(false, true) end)
		hl.bind(mainMod .. " + CTRL + period", function() move_workspace(true, true) end)



		hl.bind(mainMod .. " + Y", function() resize_window(Axis.horizontal, true) end)
		hl.bind(mainMod .. " + SHIFT + Y", function() resize_window(Axis.horizontal, false) end)
		hl.bind(mainMod .. " + U", function() resize_window(Axis.vertical, true) end)
		hl.bind(mainMod .. " + SHIFT + U", function() resize_window(Axis.vertical, false) end)

		hl.bind(mainMod .. " + P", hl.dsp.layout("promote"))
		hl.bind(mainMod .. " + SHIFT + P", function()
			hl.dispatch(hl.dsp.layout("promote"))
			hl.dispatch(hl.dsp.layout("swapcol l"))
		end)
	end
}
