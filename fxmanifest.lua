fx_version 'cerulean'
game 'gta5'

description 'QB-AdvancedShops'
author 'Jimmy#0006'
version '1.0.0'


shared_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    '@qb-core/shared/locale.lua',
    'locale/en.lua', -- replace
    'config.lua'
}

client_script 'client/main.lua'
server_script {'@oxmysql/lib/MySQL.lua','server/main.lua', }

lua54 'yes'
