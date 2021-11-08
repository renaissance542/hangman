# frozen_string_literal: true
require 'json'

# game data stored here
class Game_data
  FILE = '5desk.txt'
  attr_accessor :secret_word, :guesses_remaining, :letters_guessed

  def initialize(secret_word = generate_secret_word, guesses_remaining = 12, letters_guessed = [])
    @secret_word = secret_word
    @guesses_remaining = guesses_remaining
    @letters_guessed = letters_guessed
  end

  def mystery_word
    word = ''
    @secret_word.each_char { |c| word += (@letters_guessed.include? c) ? c : '_' }
    word
  end

  def to_json(*)
    JSON.dump ({
      secret_word: @secret_word,
      guesses_remaining: @guesses_remaining,
      letters_guessed: @letters_guessed
    })
  end

  def self.from_json(string)
    data = JSON.load string
    Game_data.new(data['secret_word'], data['guesses_remaining'], data['letters_guessed'])
  end

  private

  def generate_secret_word
    return nil unless File.exist?(FILE)

    # load File contents into word array & reduce array to eligible words
    File.readlines(FILE, chomp: true).filter { |word| word.length.between?(5, 12) }.sample.downcase
  end
end
