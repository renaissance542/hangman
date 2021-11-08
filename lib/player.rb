# frozen_string_literal: true

require 'pry'

# IO class for the game
class Player
  def welcome_message
    puts "\nWelcome to Hangman"
  end

  def goodbye_message
    puts "\nGoodbye!"
  end

  def print_main_menu
    # load game, play game, quit
    puts <<~MENU
      \n*** Main Menu ***
        1. Print rules
        2. Play a new game
        3. Load a saved game
        4. Quit
      Enter a number:
    MENU
  end

  def menu_input
    puts 'Invalid Input. Enter a number from 1 to 4' until (input = gets.chomp.to_i).between?(1, 4)
    input
  end

  def get_guess(game_data)
    print_guess_prompt(game_data)
    input_guess(game_data)
  end

  def input_guess(game_data)
    prompt = "Invalid Input.  Guess a new letter, the whole word, or type 'save' or 'quit'"
    puts prompt until valid_guess?(input = gets.chomp, game_data)
    input
  end

  def print_guess_prompt(game_data)
    puts <<~PROMPT
      \nThe mystery word is #{game_data.mystery_word}
      You have already guessed #{game_data.letters_guessed}
      You have #{game_data.guesses_remaining} guesses remaining.
      Guess a single letter or the whole word, or type
      'save' or 'quit'
    PROMPT
  end

  def valid_guess?(input, game_data)
    if (input.length == 1 && !game_data.letters_guessed.include?(input)) ||
       (%w[save quit].include?(input.downcase)) ||
       (input.length == game_data.secret_word.length)
      true
    else
      false
    end
  end

  def print_rules
    puts <<~RULES
      \nGuess the word to win.
      A random word is secretly chosen.
      Guess a letter.  If the letter is in the word,
      you will see where it goes.  If the letter is not
      in the word, you get a strike.

      If you complete the word before getting 12 strikes,
      then you win.

      You may also attempt to guess the entire word on your
      turn, but you will get a strike if your guess is incorrect.

      Good luck!
    RULES
  end
end
