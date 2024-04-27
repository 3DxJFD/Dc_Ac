module IDKProgramming
  module DcAc

    # Extension version
    VERSION = "0.0.0"

    # Extension information
    EXTENSION_NAME = "Dc Ac"
    LOADER_PATH = "dc_ac/dc_ac_loader.rb"
    CREATOR = "IDK Programming"  
    COPYRIGHT = "©2023 3D x JFD"  
    DESCRIPTION = 'An extension that interacts with Dynamic Components using an HTML Dialog.'

    # SketchupExtension instance
    extension = SketchupExtension.new(EXTENSION_NAME, LOADER_PATH)
    extension.version = VERSION
    extension.creator = CREATOR
    extension.copyright = COPYRIGHT
    extension.description = DESCRIPTION
    
    # Register extension with the SketchupExtensionManager
    Sketchup.register_extension(extension, true)

  end 
end
