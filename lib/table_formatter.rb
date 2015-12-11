class TableFormatter
  attr_accessor :header, :entries

  def initialize(header:, entries:)
    self.header = header
    self.entries = entries
  end

  def header_line
    format_row(header)
  end

  def horizontal_border
    format_row(Array.new(header.size, ''), '-', '+')
  end

  def column_width(column_name)
    [*values_for_column(column_name), column_name.to_s].max_by(&:length).length
  end

  def values_for_column(column_name)
    entries.map { |entry| entry[column_name.to_sym].to_s }
  end

  def entry_row(entry)
    ordered_entry = header.map { |header| entry[header.to_sym].to_s }
    format_row(ordered_entry)
  end

  def entry_rows
    entries.map { |entry| entry_row(entry) }.join("\n")
  end

  protected

  def column_widths
    @column_widths ||= header.map { |header| column_width(header) }
  end

  def format_row(column_values, filler = ' ', column_sep = '|')
    padded_column_values = []
    column_values.each_with_index do |column_value, index|
      padded_column_values << column_value.ljust(column_widths[index], filler)
    end
    "#{padded_column_values.join(column_sep)}#{column_sep}"
  end
end
