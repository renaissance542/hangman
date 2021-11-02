# frozen_string_literal: true

# Hangman game to guess a word
class Game
  FILE = '5desk.txt'

  def initialize
    @secret_word = generate_secret_word
    @guesses_remaining = 12
    @letters_guessed = []
  end

  def mystery_word
    word = ''
    @secret_word.each_char { |c| word += (@letters_guessed.include? c) ? c : '_' }
    word
  end

  def generate_secret_word
    return nil unless File.exist?(FILE)

    # load File contents into word array & reduce array to eligible words
    word_list = File.readlines(FILE).map(&:chomp).filter { |word| word.between?(5, 12) }
    word_list.sample
  end
end
