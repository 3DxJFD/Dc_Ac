puts "Executing Dc_Ac_main.rb"
require 'sketchup.rb'

module IDK_Programming
    module Dc_Ac

        PLUGIN_PATH ||= File.dirname(__FILE__)

        # Module-level variable to hold the dialog reference
        @dialog = nil

        # Method to access the module-level variable
        def self.dialog
            @dialog
        end

        class DcSelectionObserver < Sketchup::SelectionObserver #But should this be a class or a local observer in the create_html_dialog method?
            def onSelectionBulkChange(selection)
                puts "Selection changed"
                if selection.single_object?
                    entity = selection[0]
                    if entity.is_a?(Sketchup::ComponentInstance) && entity.attribute_dictionary("dynamic_attributes")
                        puts "DC selected, updating attributes"
                        IDK_Programming::Dc_Ac.update_dc_attributes_display(IDK_Programming::Dc_Ac.dialog, entity)
                    else
                        # Clear the attributes display if the selection is not a DC
                        IDK_Programming::Dc_Ac.clear_dc_attributes_display(IDK_Programming::Dc_Ac.dialog)
                    end
                else
                    # Clear the attributes display if there's no single object selected
                    IDK_Programming::Dc_Ac.clear_dc_attributes_display(IDK_Programming::Dc_Ac.dialog)
                end
            end
        end

        def self.create_html_dialog
            @dialog = UI::HtmlDialog.new(
            {
                :dialog_title => "DC AC",
                :preferences_key => "com.Dc_Ac",
                :scrollable => true,
                :resizable => true,
                :width => 300,
                :height => 500,
                :left => 100,
                :top => 100,
                :min_width => 50,
                :style => UI::HtmlDialog::STYLE_DIALOG
            })

            @dialog_instance = dialog

            dialog.set_file(File.join(File.dirname(__FILE__), 'html', 'Dc_Ac.html'))

            dialog.add_action_callback("getInputs") do |context, input_data|
                # Split the input_data string into individual values
                input_values = input_data.split(',')
                puts "Input 1: #{input_values[0]}, Input 2: #{input_values[1]}"
            end

            dialog.add_action_callback("getDcAttributes") do |context|
                get_dc_attributes(dialog)
            end

            # Attach the selection observer without any arguments
            observer = DcSelectionObserver.new
            Sketchup.active_model.selection.add_observer(observer)

            # Set the on-closed callback for the dialog
            @dialog.set_on_closed {
                # Detach the selection observer when the dialog is closed
                Sketchup.active_model.selection.remove_observer(observer)
            }

            dialog.show
        end

        def self.create_toolbar
            puts "Creating DC AC Toolbar..."
            toolbar = UI::Toolbar.new("DC AC Toolbar")
        
            cmd = UI::Command.new("Open HTML Dialog") {
                self.create_html_dialog
            }
        
            icon_path = File.join(File.dirname(__FILE__), 'icons', 'DC-AC.png')
            cmd.small_icon = icon_path
            cmd.large_icon = icon_path
            cmd.tooltip = "Open DC AC"
            cmd.status_bar_text = "Opens the DC AC dialog"
            cmd.menu_text = "Open HTML Dialog"
        
            toolbar.add_item(cmd)
            toolbar.show
        end

        def self.add_menu_item
            unless file_loaded?(__FILE__)
                menu = UI.menu('Extensions')
                menu.add_item('Open DC AC Dialog') {
                    self.create_html_dialog
                }
                file_loaded(__FILE__)
            end
        end

        def self.get_dc_attributes(dialog)
            model = Sketchup.active_model
            selection = model.selection
            return unless selection.length == 1
            
            entity = selection[0]
            return unless entity.is_a?(Sketchup::ComponentInstance)
            
            dynamic_attributes = entity.attribute_dictionary("dynamic_attributes")
            return unless dynamic_attributes
        
            attributes_str = dynamic_attributes.map { |key, value| "#{key}: #{value}" }.join("\n")
            dialog.execute_script("updateDcAttributesDisplay(#{attributes_str.inspect})")
        end 
        
        def self.update_dc_attributes_display(dialog, entity)
            puts "Updating DC attributes display"
            dynamic_attributes = entity.attribute_dictionary("dynamic_attributes")
            return unless dynamic_attributes
        
            attributes_str = dynamic_attributes.map { |key, value| "#{key}: #{value}" }.join("<br>")
            puts "Attributes to display: #{attributes_str}"
            dialog.execute_script("updateDcAttributesDisplay(#{attributes_str.inspect})") if dialog && dialog.visible?
        end

        def self.clear_dc_attributes_display(dialog)
            puts "Clearing DC attributes display"
            if dialog && dialog.visible?
                dialog.execute_script("clearDcAttributesDisplay()")
            end
        end
        
        self.add_menu_item

        # Call create_toolbar directly
        self.create_toolbar

    end
end