require 'yaml'

class ParameterTable
  attr_accessor :parameter_table, :view
  attr_accessor :data_array

  def populate(array_of_data)
    @parameter_table.registerForDraggedTypes([NSPasteboardTypeString])
    
    @data_array = array_of_data
    reload!
  end

  def get_parameters
    lambda { @data_array }
  end

  def reload!
    @parameter_table.reloadData
  end

  def numberOfRowsInTableView view
    @data_array.size rescue 0
  end

  def tableView(view, objectValueForTableColumn: column, row: index)
    row = @data_array[index]
    row.send column.identifier.to_sym
  end
  
  def tableViewSelectionDidChange notification
    if @parameter_table.selectedRow == -1
      @data_array << Parameter.new
      reload!
    end
    puts "Recieved view selection change notification. Row Index: #{@parameter_table.selectedRow}"
  end

  def tableView(view, setObjectValue: value, forTableColumn: column, row: index)
    row = @data_array[index]
    get_setter = column.identifier + "="
    
    row.send(get_setter.to_sym, value)
    reload!
  end

  def tableView(view, writeRowsWithIndexes: rowIndexes, toPasteboard: pboard)
    row_data_array = []
    rowIndexes.each do |row|
      row_data_array << @data_array[row].to_a
    end
    
    pboard.setString(row_data_array.to_yaml.to_s, forType: NSPasteboardTypeString)

    puts "Drop copied to pboard"

    @old_row_indexes = rowIndexes
    return true
  end

  def tableView(view, validateDrop:info, proposedRow:row, proposedDropOperation:op)
    puts "Validating drop"
    
    if op == NSTableViewDropAbove #is the proposed row going to be dropped between rows?
         return NSDragOperationEvery 
    else
         return NSDragOperationNone #it isn't between rows, deny the proposed drop
    end
  end

  def tableView(view, acceptDrop: info, row: droppedRow, dropOperation: op)
    puts "Accepted Drop"
    pboard = info.draggingPasteboard
    row_data_array = YAML.load(pboard.stringForType(NSPasteboardTypeString))

    puts droppedRow

    row_data_array.reverse.each do |row|
      @data_array.insert(droppedRow, Parameter.new(sign: row[0]["sign"], key: row[0]["key"], value: row[0]["value"]))
    end

    @old_row_indexes.each do |x|
      x += 1 if x > droppedRow
      @data_array.delete_at(x)
    end
    
    @parameter_table.deselectAll(nil)
    reload!

    return true
  end
end
