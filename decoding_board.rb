# frozen_string_literal: true

# The DecodingBoard class represents a Mastermind board. It holds the board game data
# and provides methods access and change this data.
class DecodingBoard
  include Interface

  attr_accessor :secret_row, :guess_rows

  def initialize(max_turns)
    @secret_row = [' ', ' ', ' ', ' ']
    @guess_rows = Array.new(max_turns) { { code: [' ', ' ', ' ', ' '], keys: [' ', ' ', ' ', ' '] } }
  end
end
