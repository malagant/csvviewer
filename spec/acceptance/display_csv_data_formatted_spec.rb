require 'spec_helper'

RSpec.feature 'Format CSV data',
              'As a "user"
              I want to see nicely formatted output
               When I call the csv viewer' do
  def captured_prog_out
    system('./bin/csv_viewer', csv_filename, page_length)
  end

  given(:csv_filename) { File.join(__dir__, '..', 'fixtures', 'formatted_csv_spec.csv') }
  given(:expected_header) { 'Name |Age|City    |' }
  given(:formatted_csv) { ' To be completed' }
  given(:page_length) { '2' }
  given(:expected_formatted_csv) do
    <<-EOF.split("\n").map(&:lstrip).join("\n")
      Name |Age|City    |
      -----+---+--------+
      Peter|42 |New York|
      Paul |57 |London  |
      Mary |35 |Munich  |
      N(ext page, P(revious page, F(irst page, L(ast page, eX(it
    EOF
  end

  scenario 'binary is called without a parameter' do
    expect { captured_prog_out }.to output(expected_formatted_csv).to_stdout_from_any_process
  end
end
