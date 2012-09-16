require 'yaml'

class ParameterTable
  attr_accessor :parameter_table, :view
  attr_accessor :data_array

  def populate(array_of_data)
    @data_array = array_of_data
    reload!
  end

  def get_parameters
    @data_array
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
    rowIndexes.each { |row| row_data_array << @data_array[row] }
    pboard.setString(row_data_array.to_yaml.to_s, forType: "Parameter")

    puts "Drop copied to pboard"

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
    row_data_array = YAML.load(pboard.stringForType("Parameter"))
    
    row_data_array.reverse.each do |row|
      # Rebuild data_array
    end

    @parameter_table.deselectAll(nil)
    reload!

    return true
  end
end
