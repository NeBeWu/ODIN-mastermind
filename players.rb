# frozen_string_literal: true

class Player
  def insert_code(row, code)
    row.code = code.chars
  end

  def insert_random_code(row)
    random_code = generate_random_code

    insert_code(row, random_code)
  end

  private

  def generate_random_code
    Array.new(4).map { |_entry| %w[B R Y P O G].sample }.join
  end
end

class Codemaker < Player
  def initialize
    super
    @black_code_entries = []
    @white_code_entries = []
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
end

class Codebreaker < Player
end
