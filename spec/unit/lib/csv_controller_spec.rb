require 'spec_helper'
require 'stringio'

class CsvController
  attr_accessor :csv_io, :header, :pager

  NEXT_PAGE = 'N'
  PREVIOUS_PAGE = 'P'
  FIRST_PAGE = 'F'
  LAST_PAGE = 'L'
  EXIT = 'X'

  def initialize(csv_io:, entries:, page_length: 20)
    self.csv_io = csv_io
    self.pager = Pager.new(entries: entries, page_length: page_length)
    self.header = entries.first.keys.map(&:to_s)
  end

  def run(key = NEXT_PAGE)
    current_table = case key
                    when /#{FIRST_PAGE}/i
                      TableFormatter.new(header: header, entries: pager.first)
                    when /#{NEXT_PAGE}/i
                      TableFormatter.new(header: header, entries: pager.next)
                    when /#{PREVIOUS_PAGE}/i
                      TableFormatter.new(header: header, entries: pager.previous)
                    when /#{LAST_PAGE}/i
                      TableFormatter.new(header: header, entries: pager.last)
                    end

    display current_table.header_line
    display current_table.horizontal_border
    display current_table.entry_rows
    display navigation
  end

  def navigation
    'N(ext page, P(revious page, F(irst page, L(ast page, eX(it'
  end

  def display(content)
    puts content
  end
end

RSpec.describe CsvController do
  let(:csv_io) { StringIO.new }
  let(:entries) do
    [
      { Name: 'Peter', Age: 42, City: 'New York' },
      { Name: 'Paul', Age: 57, City: 'London' },
      { Name: 'Mary', Age: 35, City: 'Munich' },
      { Name: 'Michael', Age: 42, City: 'Borghorst' },
      { Name: 'Hans', Age: 37, City: 'Hamburg' },
      { Name: 'Spacken', Age: 15, City: 'Münster' },
      { Name: 'Helge', Age: 60, City: 'Mühlheim' }
    ]
  end

  let(:first_page) do
    <<-EOF.split("\n").map(&:lstrip).join("\n") + "\n"
      Name |Age|City    |
      -----+---+--------+
      Peter|42 |New York|
      Paul |57 |London  |
      Mary |35 |Munich  |
      N(ext page, P(revious page, F(irst page, L(ast page, eX(it
    EOF
  end

  let(:second_page) do
    <<-EOF.split("\n").map(&:lstrip).join("\n") + "\n"
      Name   |Age|City     |
      -------+---+---------+
      Michael|42 |Borghorst|
      Hans   |37 |Hamburg  |
      Spacken|15 |Münster  |
      N(ext page, P(revious page, F(irst page, L(ast page, eX(it
    EOF
  end

  let(:last_page) do
    <<-EOF.split("\n").map(&:lstrip).join("\n") + "\n"
      Name |Age|City    |
      -----+---+--------+
      Helge|60 |Mühlheim|
      N(ext page, P(revious page, F(irst page, L(ast page, eX(it
    EOF
  end

  subject { CsvController.new(csv_io: csv_io, entries: entries, page_length: 3) }

  describe '#run' do
    it 'prints the first page' do
      expect { subject.run }.to output(first_page).to_stdout
    end

    it 'prints the second page' do
      subject.run
      expect { subject.run(CsvController::NEXT_PAGE) }.to output(second_page).to_stdout
    end

    it 'prints the last page' do
      subject.run
      expect { subject.run(CsvController::LAST_PAGE) }.to output(last_page).to_stdout
    end

    it 'prints the second page again' do
      subject.run(CsvController::NEXT_PAGE)
      subject.run(CsvController::NEXT_PAGE)
      expect { subject.run(CsvController::PREVIOUS_PAGE) }.to output(second_page).to_stdout
    end

    it 'prints the second page again' do
      subject.run(CsvController::LAST_PAGE)
      expect { subject.run(CsvController::PREVIOUS_PAGE) }.to output(second_page).to_stdout
    end
  end
end
