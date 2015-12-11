require 'spec_helper'

RSpec.describe TableFormatter do
  let(:expected_header) { 'Name |Age|City    |' }
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
    it 'returns a formatted header' do
      expect(subject.header_line).to eq(expected_header)
    end
  end

  describe '#entry_rows' do
    let(:expected_entry_rows) do
      <<-EOF.split("\n").map(&:lstrip).join("\n")
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
    let(:expected_entry_row) do
      <<-EOF.split("\n").map(&:lstrip).join("\n")
      Peter|42 |New York|
      EOF
    end

    let(:entry) { { Name: 'Peter', Age: 42, City: 'New York' } }
    it 'returns formatted entry row' do
      expect(subject.entry_row(entry)).to eq(expected_entry_row)
    end
  end

  describe '#column_width' do
    let(:city_col_width) { 8 }
    it 'returns the width of the longest value in column' do
      expect(subject.column_width('City')).to eq(city_col_width)
    end

    it 'accepts a symbol as column name' do
      expect(subject.column_width(:City)).to eq(city_col_width)
    end

    let(:age_col_width) { 2 }
    it 'returns the width of the longest value in column' do
      expect(subject.column_width('Age')).to eq(age_col_width)
    end

    it 'accepts a symbol as column name' do
      expect(subject.column_width(:Age)).to eq(age_col_width)
    end

    let(:age_col_width) { 3 }

    it 'works with numerical values' do
      expect(subject.column_width(:Age)).to eq(age_col_width)
    end

    let(:age_header_col_width) { 3 }
    it 'returns header length if it is longer' do
      expect(subject.column_width(:Age)).to eq(age_header_col_width)
    end
  end

  describe '#values_for_column' do
    it 'returns all values' do
      expect(subject.values_for_column(:City)).to eq(entries.map { |entry| entry[:City] })
    end
  end

  describe '#horizontal_border' do
    let(:expected_border) { '-----+---+--------+' }
    it 'returns a formatted horizontal border' do
      expect(subject.horizontal_border).to eq(expected_border)
    end
  end
end
