#
#  AppDelegate.rb
#  APEYE
#
#  Created by Brady Love on 9/13/12.
#  Copyright 2012 Brady Love. All rights reserved.
#
require 'net/http'
require 'open-uri'
require 'json'

class AppDelegate
  attr_accessor :window
  attr_accessor :send_button, :verb_dropdown, :data_type_dropdown
  attr_accessor :url_text_field, :output_text_field, :pem_file_location_text_field
  attr_accessor :request_text_field
  attr_accessor :parameter_table, :recent_requests
  attr_accessor :sign_checkbox

  def awakeFromNib
    @parameters = [Parameter.new(sign: false, key: "", value: "")]

    @recent_requests.populate
    @parameter_table.populate @parameters
  end

  def applicationDidFinishLaunching(a_notification)
    # Insert code here to initialize your application
  end

  def keyDown(event)
    puts "Key Down Somethings"
    puts "Key Pressed: " + event.characters

    super(event)
  end

  def send_button_clicked(sender)
    @recent_requests.update_recent_urls
    @parameter_table.get_parameters.each do |x|
      x.to_puts
    end
    
    uri  = URI(@recent_requests.combo_box.stringValue)
    
    http    = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP.const_get(get_http_verb).new(uri.request_uri)
    request.content_type = "application/json"

    resp = http.request(request, request_data.to_json)

    data = JSON.parse(resp.body, symbolize_names: true)

    @request_text_field.setString(JSON.pretty_generate(request_data))
    @output_text_field.setString(JSON.pretty_generate(data))
  end

  def request_data
    data_hash = {}
    
    @parameter_table.get_parameters.each do |x|
      data_hash[x.key.to_sym] = x.value unless x.empty?
    end
    
    if @sign_checkbox.state == NSOnState
      path_to_pem   = @pem_file_location_text_field.stringValue
      signature_b64 = Crypto.new(path_to_pem, @parameter_table.get_parameters).sign_and_encode

      data_hash[:signature_b64] = signature_b64
    end
    
    data_hash
  end

  def get_http_verb
    selected_verb  = @verb_dropdown.selectedItem.title
    formatted_verb = selected_verb[0] + selected_verb[1..-1].swapcase

    formatted_verb.to_sym
  end

  def browse_button_clicked(sender)
    file_picker = NSOpenPanel.openPanel
    file_picker.canChooseFiles          = true
    file_picker.canChooseDirectories    = false
    file_picker.allowsMultipleSelection = false

    if file_picker.runModalForDirectory(nil, file: nil) == NSOKButton
      @pem_file_location = file_picker.filenames.first
      @pem_file_location_text_field.stringValue = @pem_file_location
      puts "Pem file picked: #{@pem_file_location}"
    end
  end
end

