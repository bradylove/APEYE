class RecentRequestDataSource
  attr_accessor :recent_requests_combo_box
  attr_accessor :data_array

  def populate
    @plist_path  = NSBundle.mainBundle.pathForResource('RecentUrls', ofType: 'plist')
    # TODO Convert switch from NSArray to NSDictionary
    @data_array = NSArray.arrayWithContentsOfFile(@plist_path)
    
    puts @data_array
    reload!
  end

  def update_recent_urls
    @data_array += [@recent_requests_combo_box.stringValue]
    @data_array.uniq!
    @data_array.writeToFile(@plist_path, atomically: true)

    reload!
  end

  def combo_box
    @recent_requests_combo_box
  end

  def reload!
    @recent_requests_combo_box.reloadData
  end

  def comboBox(box, objectValueForItemAtIndex: index)
    row = @data_array[index]

    row
  end

  def numberOfItemsInComboBox box
    @data_array.size rescue 1
  end
end
