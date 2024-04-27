puts "Loading dc_ac_loader.rb"

module IDKProgramming
  module DcAc

    # Define PLUGIN_PATH constant
    PLUGIN_PATH ||= File.dirname(__FILE__)

    # Require the main Ruby file
    require File.join(PLUGIN_PATH, 'dc_ac_main.rb')

    # Define the icon path globally within the module
    ICON_PATH = File.join(PLUGIN_PATH, "icons", "dc_ac.png").freeze 

    PLUGIN_PATH_HTML = File.join(PLUGIN_PATH, 'html')
    PLUGIN_PATH_IMAGE = File.join(PLUGIN_PATH, 'icons')
    PLUGIN_PATH_JS = File.join(PLUGIN_PATH, 'js')

  end
end