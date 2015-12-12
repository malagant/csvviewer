require 'spec_helper'

RSpec.describe TableFormatter do
  let(:header) { %w(Name Age City) }
  let(:entries) do
    [
      { Name: 'Peter', Age: 42, City: 'New York' },
      { Name: 'Paul', Age: 57, City: 'London' },
      { Name: 'Mary', Age: 35, City: 'Munich' }
    ]
  end
  subject { TableFormatter.new(header: header, entries: entries) }

  describe '#header_line' do
    let(:expected_header_line) { 'Name |Age|City    |' }

    it 'returns an formatted header' do
      expect(subject.header_row).to eq(expected_header_line)
    end
  end

  describe '#entry_rows' do
    let(:expected_entry_rows) do
      <<-EOF.split("\n").map(&:lstrip)
      Peter|42 |New York|
      Paul |57 |London  |
      Mary |35 |Munich  |
      EOF
    end

    it 'returns formatted entry rows' do
      expect(subject.entry_rows).to eq(expected_entry_rows)
    end
  end

  describe '#entry_row' do
    let(:expected_entry_row) { 'Peter|42 |New York|' }
    let(:entry) { { Name: 'Peter', Age: 42, City: 'New York' } }

    it 'returns formatted entry row' do
      expect(subject.entry_row(entry)).to eq(expected_entry_row)
    end
  end

  describe '#horizontal_border' do
    let(:expected_horizontal_border) { '-----+---+--------+' }

    it 'returns an border line' do
      expect(subject.horizontal_border).to eq(expected_horizontal_border)
    end
  end

  describe '#column_width' do
    let(:city_col_width) { 8 }
    let(:age_col_width) { 3 }

    it 'returns the width for the longest value in a column' do
      expect(subject.column_width('City')).to eq(city_col_width)
    end

    it 'accepts a symbol as column name' do
      expect(subject.column_width(:City)).to eq(city_col_width)
    end

    it 'returns the header length if it is longer' do
      expect(subject.column_width(:Age)).to eq(age_col_width)
    end
  end

  describe '#values_for_col' do
    it 'returns all values' do
      expected_entries = entries.map { |entry| entry[:City] }
      expect(subject.values_for_col(:City)).to eq(expected_entries)
    end
  end
end
