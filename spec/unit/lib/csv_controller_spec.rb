require 'spec_helper'
require 'stringio'

class CsvController
  NEXT_PAGE = 'N'
  PREVIOUS_PAGE = 'P'
  FIRST_PAGE = 'F'
  LAST_PAGE = 'L'

  attr_accessor :pager, :header, :screen_io

  def initialize(csv_io:, screen_io: $stdout,entries:, page_length: 20)
    self.pager = Pager.new(entries: entries, page_length: page_length)
    self.header = entries.first.keys.map(&:to_s)
    self.screen_io = screen_io
  end

  def run(key=NEXT_PAGE)
    current_table = case key
                      when /#{NEXT_PAGE}/i
                        TableFormatter.new(header: header, entries: pager.next)
                      when /#{PREVIOUS_PAGE}/i
                        TableFormatter.new(header: header, entries: pager.previous)
                      when /#{LAST_PAGE}/i
                        TableFormatter.new(header: header, entries: pager.last)
                      when /#{FIRST_PAGE}/i
                        TableFormatter.new(header: header, entries: pager.first)
                    end


    display current_table.header_row
    display current_table.horizontal_border
    current_table.entry_rows.each {|row| display row }

    display navigation
  end

  def navigation
    "N(ext page, P(revious page, F(irst page, L(ast page, eX(it"
  end

  def display(msg)
    screen_io.puts msg
  end
end

class FakeIo
  def data
    @data ||= []
  end

  def clear
    @data = []
  end

  def puts(msg)
    data << msg
  end
end

RSpec.describe CsvController do
  let(:csv_io) { StringIO.new }
  let(:entries) do
    [
        { Name: 'Peter', Age: 42, City: 'New York' },
        { Name: 'Paul', Age: 57, City: 'London' },
        { Name: 'Mary', Age: 35, City: 'Munich' },
        { Name: 'Max', Age: 42, City: 'Paris' },
        { Name: 'Louisa', Age: 57, City: 'Amsterdam' },
        { Name: 'Johanna', Age: 35, City: 'Zurich' },
        { Name: 'Marcus', Age: 45, City: 'Munich' }
    ]
  end

  let(:first_page) do
    <<-EOF.split("\n").map(&:lstrip)
      Name |Age|City    |
      -----+---+--------+
      Peter|42 |New York|
      Paul |57 |London  |
      Mary |35 |Munich  |
      N(ext page, P(revious page, F(irst page, L(ast page, eX(it
    EOF
  end

  let(:second_page) do
    <<-EOF.split("\n").map(&:lstrip)
      Name   |Age|City     |
      -------+---+---------+
      Max    |42 |Paris    |
      Louisa |57 |Amsterdam|
      Johanna|35 |Zurich   |
      N(ext page, P(revious page, F(irst page, L(ast page, eX(it
    EOF
  end

  let(:last_page) do
    <<-EOF.split("\n").map(&:lstrip)
      Name  |Age|City  |
      ------+---+------+
      Marcus|45 |Munich|
      N(ext page, P(revious page, F(irst page, L(ast page, eX(it
    EOF
  end

  let(:screen_io) { FakeIo.new }
  subject { CsvController.new(csv_io: csv_io, screen_io: screen_io ,entries: entries, page_length: 3) }

  describe '#run' do
    it 'prints the first page' do
      subject.run
      expect(screen_io.data).to eq(first_page)
    end

    it 'prints the next page when param is "N" ' do
      subject.run(CsvController::NEXT_PAGE)
      screen_io.clear
      subject.run(CsvController::NEXT_PAGE)

      expect(screen_io.data).to eq(second_page)
    end

    it 'prints the next page when param is "P" ' do
      subject.run(CsvController::LAST_PAGE)
      screen_io.clear
      subject.run(CsvController::PREVIOUS_PAGE)
      expect(screen_io.data).to eq(second_page)
    end

    it 'prints the first page when param is "F" ' do
      subject.run(CsvController::LAST_PAGE)
      screen_io.clear
      subject.run(CsvController::FIRST_PAGE)

      expect(screen_io.data).to eq(first_page)
    end

    it 'prints the last page when param is "L" ' do
      subject.run(CsvController::LAST_PAGE)
      expect(screen_io.data).to eq(last_page)
    end
  end
end