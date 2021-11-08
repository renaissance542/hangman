# frozen_string_literal: true

require_relative 'game_data' # game data
require_relative 'player' # player interface

# controller for data and player classes
class Hangman
  
  def initialize
    @player = Player.new
    @game_over = false
    @game_won = false
  end

  def run_app
    @player.welcome_message
    main_menu_loop
    @player.goodbye_message
  end

  def main_menu_loop
    @player.print_main_menu
    resolve_menu_input(@player.menu_input) until @quit
  end

  # rubocop:disable Metrics/MethodLength
  def resolve_menu_input(input)
    case input
    when 1 # rules
      @player.print_rules
    when 2 # play
      @game_data = Game_data.new
      play_game
    when 3 # load
      @game_data = restore_game
      play_game
    when 4 # quit
      @quit = true
    end
  end
  # rubocop:enable Metrics/MethodLength

  def play_game
    resolve_input(@player.get_guess(@game_data)) until @game_over
  end

  def resolve_input(input)
    case input
    when 'save'
      save_game
    when 'quit'
      @game_over = true
    else
      resolve_guess(input)
    end
  end

  def resolve_guess(guess)
    @game_data.guesses_remaining -= 1
    @game_over = true if @game_data.guesses_remaining.zero?
    resolve_guessed_letter(guess) if guess.length == 1
    resolve_guessed_word(guess) if guess.length > 1
  end

  def resolve_guessed_letter(letter)
    @game_data.letters_guessed.push(letter)
    check_victory
  end

  def check_victory
    correct_letters = @game_data.letters_guessed & @game_data.secret_word.chars.uniq
    return unless correct_letters == @game_data.secret_word.chars.uniq

    @game_won = true
    @game_over = true
  end

  def resolve_guessed_word(word)
    return unless word.downcase == @game_data.secret_word

    @game_won = true
    @game_over = true
  end

  def save_game
    File.open('saved_game', 'w+') { |f| f.puts @game_data.to_json } # IOstream auto-closed
    puts 'Saving Game'
  end

  # load game:  read JSON file and create @data object
  def restore_game
    return Game_data.new unless File.exist?('saved_game')

    Game_data.from_json(File.read('saved_game'))
  end
end

