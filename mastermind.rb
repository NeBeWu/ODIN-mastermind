# frozen_string_literal: true

require_relative 'decoding_board'
require_relative 'players'

class Game
  def initialize
    @decoding_board = DecodingBoard.new
    if choose_player == '1'
      @codebreaker = Codebreaker.new('human')
      @codemaker = Codemaker.new('computer')
    else
      @codebreaker = Codebreaker.new('computer')
      @codemaker = Codemaker.new('human')
    end
    @turn = -1
  end

  def choose_player
    puts 'Which player do you want to be? Enter 1 for codebreaker or 2 for codemaker'

    player_option = gets.chomp

    until validate_option(player_option)
      puts 'Invalid input! Please enter 1 for codebreaker or 2 for codemaker.'
      player_option = gets.chomp
    end

    player_option
  end

  def play
    puts 'Let\'s play mastermind!'
    @codemaker.create_code(@decoding_board.shielded_row)
    play_turn until end_round?
    code_broken? ? puts('Congratulations! You broke the code!') : puts("Too bad! You couldn't break the code")
  end

  def play_turn
    end_round?
    @turn += 1
    codebreaker_input
    codemaker_output
    @decoding_board.show_board
  end

  def codebreaker_input_human
    puts "Please insert your code #{@codebreaker.name}."
    guess_code = gets.chomp

    until validate_code(guess_code)
      puts 'Invalid input! Please insert valid guess codebreaker.'
      guess_code = gets.chomp
    end

    @codebreaker.insert_code(@decoding_board.guess_rows[@turn], guess_code)
  end

  def codebreaker_input
    if @codebreaker.type == 'computer'
      guess_code = @codebreaker.filter_possible_guesses(@decoding_board.guess_rows[@turn - 1]).sample if @turn >= 1
      guess_code = @codebreaker.possible_guesses.sample if @turn == 0
      @codebreaker.insert_code(@decoding_board.guess_rows[@turn], guess_code.join)
    else
      codebreaker_input_human
    end
  end

  def codemaker_output
    black_keys = @codemaker.compute_black_code_entries(@decoding_board.guess_rows[@turn],
                                                       @decoding_board.shielded_row).length
    white_keys = @codemaker.compute_white_code_entries(@decoding_board.guess_rows[@turn],
                                                       @decoding_board.shielded_row).length

    @codemaker.insert_keys(@decoding_board.guess_rows[@turn], black_keys, white_keys)
    @codemaker.reset_entries
  end

  def validate_option(option)
    option.match?(/^[12]{1}$/)
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
