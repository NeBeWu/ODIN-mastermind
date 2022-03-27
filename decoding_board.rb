# frozen_string_literal: true

class Row
  attr_accessor :code_entries

  def initialize
    @code_entries = Array.new(4, ' ')
  end
end

class ShieldedRow < Row
end

class GuessRow < Row
  attr_accessor :key_entries

  def initialize
    super
    @key_entries = Array.new(4, ' ')
  end
end

class DecodingBoard
  attr_accessor :guess_rows, :shielded_row

  def initialize
    @guess_rows = Array.new(12) { GuessRow.new }
    @shielded_row = ShieldedRow.new
  end

  def show_board
    p @shielded_row
    @guess_rows.each { |guess_row| puts "#{guess_row.code_entries} -- #{guess_row.key_entries}" }
  end
end
