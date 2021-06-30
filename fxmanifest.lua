fx_version 'cerulean'
game 'gta5'
author 'Linden'
description 'https://github.com/thelindat/linden_threads'

client_scripts {
	'@es_extended/imports.lua',
}

shared_scripts {
	'shared/*.lua'
}

files {
	'shared/interval.lua',	-- Load in any resource with	shared_script '@linden_thread/shared/interval.lua
}
