local function resize_window(direction, grow)
	if direction == "up" or direction == "down" then
	else
		if grow then
			hl.dispatch(hl.dsp.layout("colresize +conf"))
		else
			hl.dispatch(hl.dsp.layout("colresize -conf"))
		end
	end
end

local function move_workspace(direction, window)
	-- "direction" isn't really used because you still can't read scrolling direction in hyperland

	if direction == "left" or direction == "right" then return end

	local next = direction == "down"

	local monitor = hl.get_active_monitor()

	local workspaces = {}

	-- Normally I'd do hl.get_workspaces(selector) but I have no idea what selector should be and it's not documented anywhere
	-- No matter what value I used it always returns *all* workspaces (even with workspace style monitor selectors)
	hl.exec_cmd("echo c" .. #(hl.get_workspaces()) .. " > /home/roguebit/help")
	hl.exec_cmd("echo m" .. monitor.id .. " >> /home/roguebit/help")
	local all_workspaces = hl.get_workspaces()

	for i = 1,#(all_workspaces) do
		hl.exec_cmd("echo " .. all_workspaces[i].id .. " on " .. all_workspaces[i].monitor.id .. " >> /home/roguebit/help")
		if all_workspaces[i].monitor.id == monitor.id then table.insert(workspaces, all_workspaces[i]) end
	end

	hl.exec_cmd("echo t" .. #(workspaces) .. " >> /home/roguebit/help")
	local current_workspace = hl.get_active_workspace()

	local index = -1
	for i = 1, #(workspaces) do
		if workspaces[i].id ~= current_workspace.id then goto continue end

		index = i
		break
		::continue::
	end

	if index == -1 then return end -- Something went wrong

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

return function(mainMod, bezier)


	hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier=bezier, style="slidevert"})

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

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
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

hl.bind(mainMod .. " + SHIFT + J", function() move_workspace("down", false) end)
hl.bind(mainMod .. " + SHIFT + K", function() move_workspace("up", false) end)
hl.bind(mainMod .. " + SHIFT + CTRL + J", function() move_workspace("down", true) end)
hl.bind(mainMod .. " + SHIFT + CTRL + K", function() move_workspace("up", true) end)

hl.bind(mainMod .. " + SHIFT + down", function() move_workspace("down", false) end)
hl.bind(mainMod .. " + SHIFT + up", function() move_workspace("up", false) end)
hl.bind(mainMod .. " + SHIFT + CTRL + down", function() move_workspace("down", true) end)
hl.bind(mainMod .. " + SHIFT + CTRL + up", function() move_workspace("up", true) end)

hl.bind(mainMod .. " + Y", function() resize_window("left", true) end)
hl.bind(mainMod .. " + SHIFT + Y", function() resize_window("left", false) end)
hl.bind(mainMod .. " + U", function() resize_window("down", true) end)
hl.bind(mainMod .. " + SHIFT + U", function() resize_window("down", false) end)

hl.bind(mainMod .. " + P", hl.dsp.layout("promote"))
hl.bind(mainMod .. " + SHIFT + P", function()
	hl.dispatch(hl.dsp.layout("promote"))
	hl.dispatch(hl.dsp.layout("swapcol l"))
end)

end
