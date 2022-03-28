# frozen_string_literal: true

require_relative 'decoding_board'
require_relative 'players'

class Game
  def initialize
    @decoding_board = DecodingBoard.new
    @codemaker = Codemaker.new
    @codebreaker = Codebreaker.new
    @turn = -1
  end

  def play
    puts 'Let\'s start!'
    @codemaker.insert_random_code(@decoding_board.shielded_row)
    play_turn until end_round?
    code_broken? ? puts('Congratulations! You broke the code!') : puts("Too bad! You couldn't break the code")
  end

  def play_turn
    codebreaker_input
    codemaker_output
    @decoding_board.show_board
  end

  def codebreaker_input
    puts 'Please insert your guess codebreaker.'
    guess_code = gets.chomp

    until validate_code(guess_code)
      puts 'Invalid input! Please insert valid guess codebreaker.'
      guess_code = gets.chomp
    end

    @codebreaker.insert_code(@decoding_board.guess_rows[@turn], guess_code)
  end

  def codemaker_output
    black_keys = @codemaker.compute_black_code_entries(@decoding_board.guess_rows[@turn],
                                                       @decoding_board.shielded_row).length
    white_keys = @codemaker.compute_white_code_entries(@decoding_board.guess_rows[@turn],
                                                       @decoding_board.shielded_row).length

    @codemaker.insert_keys(@decoding_board.guess_rows[@turn], black_keys, white_keys)
    @codemaker.reset_entries
  end

  def validate_code(code)
    code.match?(/^[BRYPOG]{4}$/)
  end

  def code_broken?
    @decoding_board.guess_rows[@turn].keys.eql?(%w[B B B B])
  end

  def no_more_turns?
    @turn >= 11
  end

  def end_round?
    code_broken? || no_more_turns?
  end
end

game = Game.new
game.play
