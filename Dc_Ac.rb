puts "Loading Dc_Ac registration file"
# encoding: UTF-8

module IDK_Programming
  module Dc_Ac

    EXTENSION = SketchupExtension.new(
      'Dc Ac',                 # The name of the extension as it will appear in SketchUp
      'Dc_Ac/Dc_Ac_loader.rb'    
    )
    EXTENSION.instance_eval {
      self.description= 'An extension to interact with Dynamic Components using an HTML Dialog.'
      self.version=     '0.0.0'
      self.copyright=   "©2023 3D x JFD"
      self.creator=     "IDK_Programming"
    }
    Sketchup.register_extension(EXTENSION, true) 

  end # extension submodule
end # top level namespace module
