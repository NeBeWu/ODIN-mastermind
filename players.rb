# frozen_string_literal: true

class Player
  attr_reader :name
  attr_accessor :type

  def initialize(type)
    @type = type
    @name = self.class
    @black_code_entries = []
    @white_code_entries = []
  end

  def insert_code(row, code)
    row.code = code.chars
  end

  def insert_random_code(row)
    random_code = generate_random_code

    insert_code(row, random_code)
  end

  def compute_black_code_entries(guess_row, shielded_row)
    guess_row.code.each_index do |entry|
      @black_code_entries << entry if guess_row.code[entry] == shielded_row.code[entry]
    end

    @black_code_entries
  end

  def filter_entries(guess_row, shielded_row)
    guess_code = guess_row.code.dup
    shielded_code = shielded_row.code.dup

    @black_code_entries.reverse_each do |entry|
      guess_code.delete_at(entry)
      shielded_code.delete_at(entry)
    end

    [guess_code, shielded_code]
  end

  def compute_white_code_entries(guess_row, shielded_row)
    guess_code, shielded_code = *filter_entries(guess_row, shielded_row)

    [3, 2, 1, 0].each do |entry|
      next unless shielded_code.include?(guess_code[entry])

      @white_code_entries << [entry, shielded_code.index(guess_code[entry])]
      shielded_code.delete_at(shielded_code.index(guess_code[entry]))
      guess_code.delete_at(entry)
    end

    @white_code_entries
  end

  def insert_keys(guess_row, black_keys, white_keys)
    black_keys.times { guess_row.keys.push('B').shift }
    white_keys.times { guess_row.keys.push('W').shift }
  end

  def reset_entries
    @black_code_entries = []
    @white_code_entries = []
  end

  private

  def generate_random_code
    Array.new(4).map { |_entry| %w[R G B Y O P].sample }.join
  end
end

class Codemaker < Player
  def create_code(shielded_row)
    return insert_random_code(shielded_row) if @type == 'computer'

    puts "Please insert your code #{@name}."
    shielded_code = gets.chomp

    until shielded_code.match?(/^[BRYPOG]{4}$/)
      puts 'Invalid input! Please insert valid guess codebreaker.'
      shielded_code = gets.chomp
    end

    insert_code(shielded_row, shielded_code)
  end
end

class Codebreaker < Player
  attr_accessor :possible_guesses

  def initialize(type)
    super
    @possible_guesses = @type == 'computer' ? generate_possible_guesses : nil
  end

  def generate_possible_guesses
    %w[R B G Y O P].product(%w[R B G Y O P], %w[R B G Y O P], %w[R B G Y O P])
  end

  def compute_possibility(guess_row, last_guess_row)
    compute_black_code_entries(guess_row, last_guess_row)
    filter_entries(guess_row, last_guess_row)
    compute_white_code_entries(guess_row, last_guess_row)
  end

  def possible?(guess, last_guess_row)
    @row = GuessRow.new
    insert_code(@row, guess.join)

    reset_entries
    compute_possibility(last_guess_row, @row)
    insert_keys(@row, @black_code_entries.length, @white_code_entries.length)
    last_guess_row.keys == @row.keys
  end

  def filter_possible_guesses(last_guess_row)
    possible_guesses.select! { |guess| possible?(guess, last_guess_row) }
  end
end
