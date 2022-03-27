# frozen_string_literal: true

class Player
  def insert_code(row, code)
    row.code_entries = code.chars
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
    guess_row.code_entries.each_index do |entry|
      @black_code_entries << [entry, entry] if guess_row.code_entries[entry] == shielded_row.code_entries[entry]
    end

    @black_code_entries
  end

  def compute_white_code_entries(guess_row, shielded_row)
    guess_code = guess_row.code_entries.dup.delete_if { |entry| @black_code_entries.include?([entry, entry]) }
    shielded_code = shielded_row.code_entries.dup.delete_if { |entry| @black_code_entries.include?([entry, entry]) }

    [0, 1, 2, 3].each do |entry|
      next unless shielded_code.include?(guess_code[entry])

      shielded_code.delete_at(shielded_code.index(guess_code[entry]))
      guess_code.delete_at(entry)
    end

    @white_code_entries
  end

  # def white_keys_logic(white_keys, guess_code, shielded_code)
  #  [0, 1, 2, 3].each do |entry|
  #    next unless (guess_code[entry] != shielded_code[entry]) &&
  #                shielded_code.include?(guess_code[entry])
  #
  #    p white_keys += 1
  #    p guess_code[entry]
  #    p shielded_code[entry]
  #    p shielded_code.index(guess_code[entry])
  #    shielded_code.delete_at(shielded_code.index(guess_code[entry]))
  #    guess_code.delete_at(entry)
  #  end
  #
  #  white_keys
  # end
  #
  # def compute_white_keys(guess_row, shielded_row)
  #  white_keys = 0
  #
  #  guess_code = guess_row.code_entries.dup
  #  shielded_code = shielded_row.code_entries.dup
  #
  #  white_keys_logic(white_keys, guess_code, shielded_code)
  # end

  def insert_keys(guess_row, black_keys, white_keys)
    black_keys.times { guess_row.key_entries.push('B').shift }
    white_keys.times { guess_row.key_entries.push('W').shift }
  end

  def reset_entries
    @black_code_entries = []
    @white_code_entries = []
  end
end

class Codebreaker < Player
end
