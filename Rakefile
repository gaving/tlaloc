require "rubygems"
require "rake"
require "choctop"

ChocTop.new do |s|

    # Remote upload target (set host if not same as Info.plist['SUFeedURL'])
    s.user     = 'gav'
    s.host     = 'brokentrain.net'
    s.remote_dir = '/home/gav/brokentrain.net/tlaloc/release/'

    # Custom DMG
    s.background_file = "background.png"

    # s.app_icon_position = [100, 90]
    # s.applications_icon_position =  [400, 90]
    # s.volume_icon = "dmg.icns"
    # s.applications_icon = "appicon.icns" # or "appicon.png"
    # s.app_icon_position = [400, 200]
    # s.applications_icon_position = [700, 900]
end
