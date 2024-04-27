puts "Executing dc_ac_main.rb"
require 'sketchup.rb'

module IDKProgramming
  module DcAc
    extend self

    PREF_KEY ||= Module.nesting[0].name.gsub('::', '_')
    PLUGIN_PATH ||= File.dirname(__FILE__)
    @dialog = nil
    @loaded = false

    def show_html_dialog
      @dialog ||= create_dialog
      attach_callbacks unless @dialog.visible?
      @dialog.visible? ? @dialog.bring_to_front : @dialog.show
    end

    def create_dialog
      UI::HtmlDialog.new({
        dialog_title: "DC AC",
        preferences_key: PREF_KEY,
        scrollable: true,
        resizable: true,
        width: 300,
        height: 200,
        style: UI::HtmlDialog::STYLE_DIALOG
      }).tap { |dialog| dialog.set_file(File.join(PLUGIN_PATH, 'html', 'dc_ac.html')) }
    end

    def attach_callbacks
      @dialog.add_action_callback("getInputs") do |_context, input_data|
        input_values = input_data.split(',')
        puts "Input 1: #{input_values[0]}, Input 2: #{input_values[1]}"
      end

      @dialog.add_action_callback("getDcAttributes") { |_context| get_dc_attributes(@dialog) }

      @dialog.set_on_closed do
        puts "Dialog closed, detaching observer..."
        Sketchup.active_model.selection.remove_observer(self)
      end
    end

    def onSelectionBulkChange(selection)
      puts "Selection changed, currently selected: #{selection.length} items"
      update_dc_attributes_display(selection)
    end

    def attach_observer
      Sketchup.active_model.selection.add_observer(self) unless @observer_attached
      @observer_attached = true
    end

    def get_dc_attributes(dialog)
      model = Sketchup.active_model
      selection = model.selection
      return unless selection.length == 1 && selection[0].is_a?(Sketchup::ComponentInstance)
      
      entity = selection[0]
      dynamic_attributes = entity.attribute_dictionary("dynamic_attributes")
      return unless dynamic_attributes
      
      attributes_str = dynamic_attributes.map { |key, value| "#{key}: #{value}" }.join("\n")
      dialog.execute_script("updateDcAttributesDisplay('#{attributes_str}')")
    end

    def update_dc_attributes_display(selection)
      return unless @dialog && @dialog.visible?
      entity = selection.first
      return unless entity && entity.is_a?(Sketchup::ComponentInstance)

      dynamic_attributes = entity.attribute_dictionary("dynamic_attributes")
      return unless dynamic_attributes
      
      attributes_str = dynamic_attributes.map { |key, value| "#{key}: #{value}" }.join("<br>")
      @dialog.execute_script("updateDcAttributesDisplay('#{attributes_str}')")
    end

    def clear_dc_attributes_display
      return unless @dialog && @dialog.visible?
      @dialog.execute_script("clearDcAttributesDisplay()")
    end

    def create_toolbar
      puts "Creating DC AC Toolbar..."
      toolbar = UI::Toolbar.new("DC AC Toolbar")
      cmd = UI::Command.new("Open HTML Dialog") { show_html_dialog }

      icon_path = File.join(PLUGIN_PATH, 'icons', 'dc_ac.png')
      cmd.small_icon = icon_path
      cmd.large_icon =icon_path
      cmd.tooltip = "Open DC AC"
      cmd.status_bar_text = "Opens the DC AC dialog"
      cmd.menu_text = "Open HTML Dialog"

      toolbar.add_item(cmd)
      toolbar.show
    end

    def add_menu_item
      unless file_loaded?(__FILE__)
        menu = UI.menu('Extensions')
        menu.add_item('Open DC AC Dialog') { show_html_dialog }
        file_loaded(__FILE__)
      end
    end

    unless @loaded
      create_toolbar
      add_menu_item
      attach_observer
      Sketchup.add_observer(self)
      @loaded = true
    end
  end
end