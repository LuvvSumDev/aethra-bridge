fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'ye

name 'aethra-bridge'
author '@luvvsum'
description 'Aethra Studios: Compatibility Bridge'
version '1.0.0'

dependency 'ox_lib'

shared_scripts {
    '@ox_lib/init.lua',
    'data/config.lua',
    'shared/init.lua'
}

client_scripts {
    'client/init.lua',
    'client/framework/*.lua',
    'client/notify/*.lua',
    'client/target/*.lua',
    'client/fuel/*.lua',
    'client/clothing/*.lua',
    'client/progress/*.lua',
    'client/dispatch/*.lua'
}

server_scripts {
    'server/init.lua',
    'server/framework/*.lua',
    'server/inventory/*.lua',
    'server/notify/*.lua'
}
