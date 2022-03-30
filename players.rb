# frozen_string_literal: true

# The Player class represents a Mastermind player. It holds the players data
# and provides methods for checking code matches.
class Player
  include Interface

  attr_reader :name

  def initialize(type)
    @type = type
    @name = self.class
  end

  def compute_keys(code1, code2)
    black_code_slots = compute_black_slots(code1, code2)
    white_code_slots = compute_white_slots(code1, code2, black_code_slots)

    [black_code_slots, white_code_slots]
  end

  def compute_black_slots(code1, code2)
    black_code_slots = []

    code1.each_index do |slot|
      black_code_slots << slot if code1[slot] == code2[slot]
    end

    black_code_slots
  end

  def compute_white_slots(code1, code2, black_code_slots)
    white_code_slots = []
    code1, code2 = *filter_entries(code1, code2, black_code_slots)

    4.times do |slot|
      next unless white?(slot, code1, code2, white_code_slots)

      white_code_slots << [slot, code2.index(code1[slot])]
      code2[code2.index(code1[slot])] = nil
    end

    white_code_slots
  end

  def filter_entries(code1, code2, black_code_slots)
    code1 = code1.dup
    code2 = code2.dup

    black_code_slots.each do |slot|
      code1[slot] = nil
      code2[slot] = nil
    end

    [code1, code2]
  end

  def white?(slot, code1, code2, white_code_slots)
    code1[slot] && code2.include?(code1[slot]) && !white_code_slots.map(&:last).include?(code2.index(code1[slot]))
  end
end

# The Codemaker class represents the codemaker role. It inherits the player data
# and provides methods for generating/inputing the secret code and checking
# if the guesses match the secret code.
class Codemaker < Player
  def make_code
    return generate_random_code if @type == 'computer'

    secret_code_input
  end

  def generate_random_code
    Array.new(4).map { |_entry| %w[R G B Y O P].sample }.join
  end

  def play_turn(guess, secret_code)
    answer = [' ', ' ', ' ', ' ']

    keys = compute_keys(guess, secret_code).map(&:length)

    keys[0].times { answer.push('B').shift }
    keys[1].times { answer.push('W').shift }

    answer
  end
end

# The Codebreaker class represents the codebreaker role. It inherits the player data
# and provides methods for guessing/inputing the secret code.
class Codebreaker < Player
  def initialize(type)
    super
    @possible_guesses = @type == 'computer' ? generate_possible_guesses : nil
  end

  def generate_possible_guesses
    %w[R B G Y O P].product(%w[R B G Y O P], %w[R B G Y O P], %w[R B G Y O P])
  end

  def play_turn(last_guess, last_keys)
    if @type == 'computer'
      filter_possible_guesses(last_guess, last_keys) unless last_guess == [' ', ' ', ' ', ' ']
      @possible_guesses.sample
    else
      code_input.chars
    end
  end

  def filter_possible_guesses(last_guess, last_keys)
    @possible_guesses.select! { |guess| possible?(guess, last_guess, last_keys) }
  end

  def possible?(guess, last_guess, last_keys)
    keys_count = compute_keys(guess, last_guess).map(&:length)

    last_keys_count = [last_keys.count('B'), last_keys.count('W')]

    last_keys_count == keys_count
  end
end
