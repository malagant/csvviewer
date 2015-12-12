class Pager
  attr_accessor :entries, :page_length, :cursor

  def initialize(entries:, page_length: 20)
    self.entries = entries
    self.page_length = page_length
    self.cursor = 0
  end

  def first
    entries[0, page_length].tap { self.cursor = 0 }
  end

  def next
    entries[cursor, page_length].tap { inc_current_page }
  end

  def inc_current_page
    self.cursor += page_length
  end

  def dec_current_page
    self.cursor -= page_length
  end

  def previous
    entries[previous_page_cursor, page_length].tap { dec_current_page }
  end

  def previous_page_cursor
    previous_page_cursor = cursor - page_length
    previous_page_cursor -= page_length unless cursor == last_offset
    previous_page_cursor < 0 ? 0 : previous_page_cursor
  end

  def cursor=(new_value)
    new_value = last_offset if new_value > last_offset
    new_value = 0 if new_value < 0

    @cursor = new_value
  end

  def last
    entries[last_offset, page_length].tap { self.cursor = last_offset }
  end

  def last_offset
    cnt_records - (cnt_records % page_length)
  end

  def cnt_records
    entries.size
  end
end
