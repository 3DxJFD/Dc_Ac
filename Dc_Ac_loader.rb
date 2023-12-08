puts "Loading Dc_Ac_loader.rb"

module IDK_Programming
  module Dc_Ac

    # Define PLUGIN_PATH constant
    PLUGIN_PATH ||= File.dirname(__FILE__)

    # Require the main Ruby file
    require File.join(PLUGIN_PATH, 'Dc_Ac_main.rb')

    PLUGIN_PATH_HTML = File.join(PLUGIN_PATH, 'html')
    PLUGIN_PATH_IMAGE = File.join(PLUGIN_PATH, 'icons')
    PLUGIN_PATH_CSS = File.join(PLUGIN_PATH, 'css')

  end
end



