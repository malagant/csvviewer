require 'spec_helper'

RSpec.describe Pager do
  let(:page_length) { 2 }
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
    [
      { Name: 'Peter', Age: 42, City: 'New York' },
      { Name: 'Paul', Age: 57, City: 'London' }
    ]
  end

  let(:second_page) do
    [
      { Name: 'Mary', Age: 35, City: 'Munich' },
      { Name: 'Max', Age: 42, City: 'Paris' }
    ]
  end

  let(:third_page) do
    [
        { Name: 'Louisa', Age: 57, City: 'Amsterdam' },
        { Name: 'Johanna', Age: 35, City: 'Zurich' },
    ]
  end

  let(:last_page) do
    [
      { Name: 'Marcus', Age: 45, City: 'Munich' }
    ]
  end

  subject { Pager.new(entries: entries, page_length: page_length) }

  describe '#next' do
    it 'returns first page on the first call' do
      expect(subject.next).to eq(first_page)
    end

    it 'returns second page on the second call' do
      subject.next
      expect(subject.next).to eq(second_page)
    end

    it 'returns last page when it already is on the last page' do
      subject.last
      subject.next
      expect(subject.next).to eq(last_page)
    end
  end

  describe '#first' do
    it 'returns the first page' do
      expect(subject.first).to eq(first_page)
    end

    it 'sets "#cursor" to first' do
      subject.last
      subject.first
      expect(subject.cursor).to eq(0)
    end
  end

  describe '#last' do
    it 'returns the last page' do
      expect(subject.last).to eq(last_page)
    end

    it 'sets "#cursor" to last' do
      subject.last
      expect(subject.cursor).to eq(6)
    end
  end

  describe '#previous' do
    it 'returns the previous page' do
      subject.next
      subject.next

      expect(subject.previous).to eq first_page
    end

    it 'sets "#cursor" to the page before' do
      subject.next
      subject.next

      expect { subject.previous }.to change { subject.cursor }.by(- page_length)
    end

    it 'shows the first page when it already is on the first page' do
      expect(subject.previous).to eq first_page
    end

    it 'shows the third page when it is on the last page' do
      subject.last
      expect(subject.previous).to eq third_page
    end
  end

  describe '#last_offset' do
    it 'return 0 when "#cnt_records" is 0' do
      allow(subject).to receive(:cnt_records).and_return 0

      expect(subject.last_offset).to eq(0)
    end

    it 'return 2 when "#cnt_records" is "#page_length" + 1' do
      allow(subject).to receive(:cnt_records).and_return 7

      expect(subject.last_offset).to eq(6)
    end
  end
end
