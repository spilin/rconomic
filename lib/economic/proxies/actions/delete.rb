module Delete
  # Returns handle with a given number.
  def delete(number)
    !!request('Delete', { "#{entity_class_name.underscore}Handle" => { 'Number' => number } })
  end
end
