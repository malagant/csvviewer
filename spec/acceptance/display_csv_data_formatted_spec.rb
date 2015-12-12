require 'spec_helper'

RSpec.feature 'Format CSV data',
              'As a "user",
               I want to see nicely formated output
               When I call the csv viewer' do
  def captured_prog_out
    system(csv_viewer, csv_filename, page_length.to_s)
  end

  given(:csv_filename) { 'display_csv_data_formated.csv' }
  given(:csv_file) { File.join(__dir__, '..', 'fixtures', csv_filename) }
  given(:page_length) { 3 }

  given(:csv_viewer) { File.join(__dir__, '..', '..', 'bin/csv_viewer') }
  given(:expected_formated_csv) do
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
    expect { captured_prog_out }.to output(expected_formated_csv)
      .to_stdout_from_any_process
  end
end
