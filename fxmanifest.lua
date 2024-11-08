fx_version "cerulean"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
description "vRedM Core"
author "vRedM"
version '1.0.0'
repository 'https://github.com/vRedM/vRedM_core'

lua54 'yes'

games {
  "gta5",
  "rdr3"
}

ui_page 'web/build/index.html'

client_script "client/**/*"
server_script "server/**/*"

files {
  'web/build/index.html',
  'web/build/**/*'
}
