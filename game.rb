# frozen_string_literal: true

require 'ruby2d'

Dir["player_interfaces/*.rb"].each { |file| require_relative file }
Dir["player_interfaces/buttons/*.rb"].each { |file| require_relative file }
Dir["players/*.rb"].each { |file| require_relative file }
Dir["cells/*.rb"].each { |file| require_relative file }

require_relative 'player_interface'
require_relative 'map'
require_relative 'cell'
require_relative 'player'

set title: 'Game 1'
set background: 'gray'
set width: 1400
set height: 1000

class Game
  attr_reader \
    :map, :player_interface,
    :players, :human_player,
    :current_turn

  HUMAN_PLAYER_COLOR = 'red'

  SOLDIER_COST = 10
  CELL_BASE_INCOME = 10
  BARBARIANS_LIMIT = 10
  AI_PLAYERS = 20

  def initialize
    @map = Map.new(self)
    @player_interface = PlayerInterface.new(self)

    initialize_players(AI_PLAYERS)
    initialize_barbarians

    @current_turn = 0
  end

  def initialize_players(players_ai_count)
    @players = []
    @human_player = Player.new(map, 'Human Player', HUMAN_PLAYER_COLOR)
    #players << @human_player
    players_ai_count.times { |i| @players << Player.new(map, "Player #{i}", [rand, rand, rand, 1.0]) }

    place_players_randomly
  end

  def initialize_barbarians
    map.unoccupied_cells.each { |cell| cell.soldiers = rand(BARBARIANS_LIMIT) }
  end

  def place_players_randomly
    @players.each { |player| map.unoccupied_cells.sample.player = player }
  end

  def start
    map.update
    player_interface.update_elements
  end

  def make_turn
    alive_players.each { |player| player.make_ai_turn unless true && player == human_player }
    alive_players.each(&:increase_gold)
    map.cells.each { |cell| cell.active_soldiers = cell.soldiers }

    @current_turn += 1
  end

  def alive_players
    players.select(&:alive?)
  end

  def reset_player_state
    map.selected_cell = nil
    map.target_cell = nil

    player_interface.selecting_target_cell = false
    player_interface.typing_number_of_soldiers_to_move = false
  end
end



game = Game.new
game.start

map = game.map
player_interface = game.player_interface
human_player = game.human_player



on :mouse_down do |event|
  clicked_button = player_interface.buttons.find { |button| button.clicked?(event) }
  clicked_cell = map.cells.find { |cell| cell.clicked?(event) }

  if clicked_button
    clicked_button.click
  elsif clicked_cell
    clicked_cell.click 
  else
    game.reset_player_state
  end

  player_interface.update_elements
  map.update
end



def type_return_key(event, player_interface, map)
  return unless event.key == 'return' && player_interface.next_turn_button.active?

  player_interface.next_turn_button.click
  player_interface.update_elements
  map.update
end

def type_input_key(event, player_interface, map)
  return unless player_interface.typing_input? && event.key.between?('0', '9')

  player_interface.cell_input_text.text += event.key
  player_interface.update_elements
end

on :key_down do |event|
  type_return_key(event, player_interface, map)
  type_input_key(event, player_interface, map)
end



show
