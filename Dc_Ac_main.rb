puts "Executing Dc_Ac_main.rb"
require 'sketchup.rb'

module IDK_Programming
    module Dc_Ac

        PLUGIN_PATH ||= File.dirname(__FILE__)

        def self.create_html_dialog
            dialog = UI::HtmlDialog.new(
            {
                :dialog_title => "DC AC",
                :scrollable => true,
                :resizable => true,
                :width => 600,
                :height => 400,
                :left => 100,
                :top => 100,
                :min_width => 50,
                :min_height => 50,
                :max_width =>1000,
                :max_height => 1000,
                :style => UI::HtmlDialog::STYLE_DIALOG
            })

            dialog.add_action_callback("handleSubmit") do |context, input_data|
                # Split the input_data string into individual values
                input_values = input_data.split(',')
                # Now you can process these values
                puts "Input 1: #{input_values[0]}, Input 2: #{input_values[1]}"
            end

            dialog.add_action_callback("fetchAttributes") do |context|
                fetch_dynamic_attributes(dialog)
            end

            # Set the HTML file to be displayed in the dialog
            dialog.set_file(File.join(File.dirname(__FILE__), 'html', 'Dc_Ac.html'))

            dialog.show
        end

        def self.create_toolbar
            puts "Creating DC AC Toolbar..."
            toolbar = UI::Toolbar.new("DC AC Toolbar")
        
            cmd = UI::Command.new("Open HTML Dialog") {
                self.create_html_dialog
            }
        
            # Ensure the icon path is correct
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

        def self.fetch_dynamic_attributes(dialog)
            model = Sketchup.active_model
            selection = model.selection
            return unless selection.length == 1
            
            entity = selection[0]
            return unless entity.is_a?(Sketchup::ComponentInstance)
            
            dynamic_attributes = entity.attribute_dictionary("dynamic_attributes")
            return unless dynamic_attributes
        
            # Format the attributes into a string
            attributes_str = dynamic_attributes.map { |key, value| "#{key}: #{value}" }.join("\n")
            
            # Send this string back to the HTML dialog
            dialog.execute_script("updateAttributes(#{attributes_str.inspect})")
        end
        
        
        self.add_menu_item

        # Call create_toolbar directly
        self.create_toolbar

    end
end