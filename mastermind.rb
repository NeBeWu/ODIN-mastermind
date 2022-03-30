# frozen_string_literal: true

require_relative 'interface'
require_relative 'decoding_board'
require_relative 'players'

# The Game class represents a Mastermind game. It provides methods for playing the
# game, initialize game data, check for winners and game end.
class Game
  include Interface

  def play
    show_intro

    @rounds = rounds_input
    @max_turns = max_turns_input
    @starting_role = starting_role_input
    @score = [0, 0]

    @rounds.times do |round|
      play_round(round)
    end

    show_game_result
  end

  def play_round(round)
    initialize_round(round)

    @decoding_board.secret_row = @codemaker.make_code.chars

    play_turn until end_round?

    @decoding_board.show_secret unless code_broken?

    update_score(round)
    show_round_result
  end

  def initialize_round(round)
    @decoding_board = DecodingBoard.new(@max_turns)

    if (round % 2) == @starting_role
      @codebreaker = Codebreaker.new('human')
      @codemaker = Codemaker.new('computer')
    else
      @codebreaker = Codebreaker.new('computer')
      @codemaker = Codemaker.new('human')
    end

    @turn = -1
    sleep(1)
  end

  def update_score(round)
    if (round % 2) == @starting_role
      @score[1] += @turn
    else
      @score[0] += @turn
    end
  end

  def play_turn
    end_round?

    @turn += 1

    codebreaker_play

    codemaker_play

    @decoding_board.show_board
  end

  def codebreaker_play
    sleep(1)

    @decoding_board.guess_rows[@turn][:code] = @codebreaker.play_turn(@decoding_board.guess_rows[@turn - 1][:code],
                                                                      @decoding_board.guess_rows[@turn - 1][:keys])
  end

  def codemaker_play
    sleep(1)

    @decoding_board.guess_rows[@turn][:keys] = @codemaker.play_turn(@decoding_board.guess_rows[@turn][:code],
                                                                    @decoding_board.secret_row)
  end

  def code_broken?
    @decoding_board.guess_rows[@turn][:keys].eql?(%w[B B B B])
  end

  def no_more_turns?
    @turn >= @max_turns - 1
  end

  def end_round?
    code_broken? || no_more_turns?
  end
end

game = Game.new
game.play
