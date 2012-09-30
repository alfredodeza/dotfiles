
require("string")
require("io")

weechat.register("smarttab", "Alfredo Deza", "0.2", "GPL3", "Smart tab handling", "", "")
weechat.event_handler_add("smarttab_keyboard")
weechat.add_keyboard_handler("smarttab_keyboard")
function smarttab_cleanup ()
	if smarttab_completion_fn then
		smarttab_completion_file:close()
		smarttab_completion_file = nil
		smarttab_completion_fn = nil
		weechat.remove_infobar()
	end
end

-- find the word under cursor
function smarttab_find_word (text, pos)
	local sub_start = 0
	while true do
		local found = string.find (text, '%W', sub_start+1)
		if not found or found >= pos then
			break
		end
		sub_start = found
	end
	sub_start = sub_start + 1

	local sub_end = string.find (text, '%W', pos)
	if not sub_end then
		sub_end = 0
	end
	sub_end = sub_end - 1

	return sub_start, sub_end, string.sub(text,sub_start,sub_end)
end

local smarttab_completion_fn = nil
local smarttab_completion_file = nil

function smarttab_cleanup ()
	if smarttab_completion_fn then
		smarttab_completion_file:close()
		smarttab_completion_file = nil
		smarttab_completion_fn = nil
		weechat.remove_infobar()
	end
end

-- handle a <tab>
function smarttab_keyboard(key, input_before, input_after)

	-- only handle <tab>
	if key ~= 'tab' then
		smarttab_cleanup()
		return weechat.PLUGIN_RC_OK()
	end

	-- skip if already completed
	if input_before ~= input_after then
		smarttab_cleanup()
		return weechat.PLUGIN_RC_OK()
	end

	local pos = tonumber(weechat.get_info ('input_pos')) + 1	-- lua index starts with 1
	local sub_start, sub_end, sub = smarttab_find_word (input_before, pos)

	if not smarttab_completion_fn then
		local file = io.popen ("look '"..sub.."'")
		smarttab_completion_fn = file:lines()
		smarttab_completion_file = file
	end

	local new_word = smarttab_completion_fn()
	if not new_word then
		smarttab_cleanup()
		return weechat.PLUGIN_RC_OK()
	end

	weechat.print_infobar(0, new_word)

	return weechat.PLUGIN_RC_OK()
end

-- vim: sw=8 ts=8 noet:
