class Pager
  attr_accessor :entries, :page_length, :current_page

  def initialize(entries:, page_length:)
    self.entries = entries
    self.page_length = page_length
    self.current_page = 0
  end

  def first
    entries[0, page_length].tap { self.current_page = 0 }
  end

  def next
    entries[offset, page_length].tap { inc_current_page }
  end

  def previous
    entries[previous_offset, page_length].tap { dec_current_page }
  end

  def previous_offset
    previous_offset = offset - 2 * page_length
    previous_offset < 0 ? 0 : previous_offset
  end

  def current_page=(value)
    value = last_page if value > last_page
    value = 0 if value < 0
    @current_page = value
  end

  def offset
    current_page * page_length
  end

  def last
    entries[last_offset, page_length].tap { self.current_page = last_page }
  end

  def last_page
    num_records.div(page_length)
  end

  def last_offset
    num_records - (num_records % page_length)
  end

  def num_records
    entries.size
  end

  protected

  def inc_current_page
    self.current_page += 1
  end

  def dec_current_page
    self.current_page -= 1
  end
end
