fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'

name 'ug-hud'
description 'HUD for UgCore Framework by UgDev'
author 'UgDev'
version '3.5'
url 'https://github.com/UgDevOfc/ug-hud'
ui_page 'html/index.html'


shared_scripts {
	'@ug-core/languages.lua',
	'languages/*.lua',
	'config.lua',
	'uiconfig.lua'
}

client_script  {
	'client/main.lua',
	'client/seatbelt.lua',
	'client/cruise.lua'
}
server_script {
	'server/main.lua',
}


files {
	'html/index.html',
	'html/css/*.css',
	'html/js/*.js'
}