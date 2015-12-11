require 'spec_helper'

RSpec.describe Pager do
  let(:page_length) { 2 }
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
    [
      { Name: 'Peter', Age: 42, City: 'New York' },
      { Name: 'Paul', Age: 57, City: 'London' }
    ]
  end

  let(:second_page) do
    [
      { Name: 'Mary', Age: 35, City: 'Munich' },
      { Name: 'Michael', Age: 42, City: 'Borghorst' }
    ]
  end

  let(:last_page) do
    [
      { Name: 'Helge', Age: 60, City: 'Mühlheim' }
    ]
  end

  subject { Pager.new(entries: entries, page_length: page_length) }

  describe '#first' do
    it 'returns the first page' do
      expect(subject.first).to eq(first_page)
    end
  end

  describe '#next' do
    it 'returns the next page' do
      expect(subject.next).to eq(first_page)
    end

    it 'returns the next page' do
      subject.next
      expect(subject.next).to eq(second_page)
    end

    it 'returns the last page when it already is on the last page' do
      subject.last
      subject.next
      expect(subject.next).to eq(last_page)
    end
  end

  describe '#previous' do
    it 'returns the previous page' do
      subject.next
      subject.next
      expect(subject.previous).to eq(first_page)
    end

    it 'returns the previous page when started with last page' do
      subject.last
      expect(subject.previous).to eq(second_page)
    end
  end

  describe '#last' do
    it 'returns the last page' do
      expect(subject.last).to eq(last_page)
    end

    it 'sets "#current_page" to last' do
      subject.last
      expect(subject.current_page).to eq(3)
    end
  end

  describe '#last_offset' do
    it 'returns 0 when "#num_records" is 0' do
      allow(subject).to receive(:num_records).and_return(0)
      expect(subject.last_offset).to eq(0)
    end

    it 'returns 2 when "#num_records" is "#page_length" + 1' do
      allow(subject).to receive(:num_records).and_return(page_length + 1)
      expect(subject.last_offset).to eq(2)
    end
  end
end
