local M = {}

local flutter_actions = {
	Run = function()
		require("flutter-tools.commands").run()
	end,
	["Hot reload"] = function()
		require("flutter-tools.commands").reload()
	end,
	["Hot restart"] = function()
		require("flutter-tools.commands").restart()
	end,
	Quit = function()
		require("flutter-tools.commands").quit()
	end,
	["Visual Debug"] = function()
		require("flutter-tools.commands").visual_debug()
	end,
	["List Devices"] = function()
		require("flutter-tools.devices").list()
	end,
	["List Emulators"] = function()
		require("flutter-tools.devices").list_emulators()
	end,
	["Open Outline"] = function()
		require("flutter-tools.outline").open()
	end,
	["Start Dev Tools"] = function()
		require("flutter-tools.dev_tools").start()
	end,
	["Clear Dev Log"] = function()
		require("flutter-tools.log").clear()
	end,
}

function M.flutter_fzf()
	local entries = {}
	for key, _ in pairs(flutter_actions) do
		table.insert(entries, "Flutter tools: " .. key)
	end

	require("fzf-lua").fzf_exec(entries, {
		prompt = "Flutter tools> ",
		actions = {
			["default"] = function(selected)
				if not selected or #selected == 0 then
					return
				end
				local selected_cmd = string.match(selected[1], "^Flutter tools: (.+)")

				if flutter_actions[selected_cmd] then
					vim.schedule(flutter_actions[selected_cmd]) -- 🔥 Run the function directly
				end
			end,
		},
	})
end

return M
