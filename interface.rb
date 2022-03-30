# frozen_string_literal: true

# The Interface module acts as the game interface. It provides methods for showing
# messages, collect player input and validate them.
module Interface
  def show(message, wait = 0)
    puts message

    sleep(wait)
  end

  def show_intro
    show("Let's play mastermind!", 1)
  end

  def show_game_score
    show("SCORE: #{@score.first} -- #{@score.last}", 1)
  end

  def show_round_result
    if code_broken?
      show("#{@codebreaker.name} broke the code!", 1)
    else
      show("#{@codebreaker.name} couldn't break the code.", 1)
    end

    show_game_score
  end

  def show_game_result
    if @score.first > @score.last
      puts 'Congratulations, you won the game!'
    elsif @score.first < @score.last
      puts 'Too bad, you lost the game!'
    else
      puts 'Well, it is a draw!'
    end
  end

  def show_board
    puts ' CODE--KEYS '
    @guess_rows.each { |guess_row| puts "|#{guess_row[:code].join}||#{guess_row[:keys].join}|" }
  end

  def show_secret
    show("SECRET-#{@secret_row.join}-")
  end

  def input(message, error_message, validation_method)
    puts message
    answer = gets.chomp

    until send(validation_method, answer)
      puts error_message
      answer = gets.chomp
    end

    answer
  end

  def rounds_input
    input('How many rounds do you want to play? It can be any even number.',
          'Invalid input! Please enter an even number.',
          :validate_rounds).to_i
  end

  def max_turns_input
    input('How many turns should each round have? It can be any number from 6 to 12.',
          'Invalid input! Please enter any number from 6 to 12.',
          :validate_max_turns).to_i
  end

  def starting_role_input
    input('Which role do you want to start playing? Enter 1 for codebreaker or 2 for codemaker',
          'Invalid input! Please enter 1 for codebreaker or 2 for codemaker.',
          :validate_starting_role).to_i - 1
  end

  def secret_code_input
    input('Please insert your secret code Codemaker.',
          'Invalid input! Please insert valid secret code Codemaker.',
          :validate_code)
  end

  def code_input
    input('Please enter your code guess Codebreaker.',
          'Invalid input! Please enter a valid code guess Codebreaker.',
          :validate_code)
  end

  def validate_rounds(rounds)
    rounds.match?(/^[0-9]{1,}$/) && rounds.to_i.even?
  end

  def validate_max_turns(max_turns)
    max_turns.match?(/^[0-9]{1,}$/) && (max_turns.to_i >= 6 && max_turns.to_i <= 12)
  end

  def validate_starting_role(role)
    role.match?(/^[12]{1}$/)
  end

  def validate_code(code)
    code.match?(/^[BRYPOG]{4}$/)
  end
end
