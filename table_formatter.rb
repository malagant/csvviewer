class TableFormatter
  attr_accessor :header, :entries

  def initialize(header:, entries:)
    self.header = header
    self.entries = entries
  end

  def horizontal_border
    formatted_row(Array.new(header.size, ''), '-', '+')
  end

  def header_row
    formatted_row(header)
  end

  def entry_rows
    entries.map do |entry|
      entry_row(entry)
    end
  end

  def entry_row(entry)
    ordered_entry = header.map { |header_name| entry[header_name.to_sym].to_s }
    formatted_row(ordered_entry)
  end

  def formatted_row(column_values, filler = ' ', column_sep = '|')
    padded_column_values = []

    column_values.each_with_index do |value, index|
      padded_column_values[index] = value.ljust(column_widths[index], filler)
    end

    "#{padded_column_values.join(column_sep)}#{column_sep}"
  end

  def column_widths
    @column_widths ||= header.map { |header| column_width(header) }
  end

  def column_width(col_name)
    [*values_for_col(col_name), col_name.to_s].max_by(&:length).length
  end

  def values_for_col(col_name)
    entries.map { |entry| entry[col_name.to_sym].to_s }
  end
end
