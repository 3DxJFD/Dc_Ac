puts "Executing Dc_Ac_main.rb"
require 'sketchup.rb'

module IDK_Programming
    module Dc_Ac

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
            
            # JavaScript callback
            dialog.add_action_callback("callback_identifier") do |action_context, data|
            # Handle callback from JavaScript
            end

            # Set the HTML file to be displayed in the dialog
            dialog.set_file(File.join(File.dirname(__FILE__), 'html', 'Dc_Ac.html'))

            dialog.show
        end

        def self.create_toolbar
            puts "Creating toolbar..."
            toolbar = UI::Toolbar.new("My Extension Toolbar")

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

            toolbar = toolbar.add_item(cmd)
            toolbar.show if toolbar.get_last_state != TB_HIDDEN
        end

        # Call create_toolbar directly
        self.create_toolbar

    end
end