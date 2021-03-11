# frozen_string_literal: true

class Cell
  include Cells::CellsRelations
  include Cells::CellProperties
  include Cells::SoldiersManagement
  include Cells::SoldiersActions
  include Cells::AIAnalysis
  include Cells::Helpers

  attr_reader \
    :square,
    :map,
    :x, :y,
    :soldiers_text

  attr_accessor \
    :player,
    :soldiers,
    :active_soldiers

  SELECTED_CELL_COLOR = 'yellow'
  TARGET_CELL_COLOR = 'green'
  FOG_COLOR = '#555555'
  NO_PLAYER_COLOR = 'white'

  def initialize(map, x, y)
    @map = map
    @x = x
    @y = y

    @soldiers = 0
    @active_soldiers = 0

    @square = Square.new(x: 52 * x + 2, y: 52 * y + 2, size: 50, color: 'gray', z: 10)
    @soldiers_text = Text.new("", x: 52 * x + 2 + 15, y: 52 * y + 2 + 15, size: 20, z: 12, color: 'black')
  end

  def color
    return SELECTED_CELL_COLOR if self == map.selected_cell
    return TARGET_CELL_COLOR if self == map.target_cell
    return FOG_COLOR if fogged?

    player&.color || NO_PLAYER_COLOR
  end

  # Обновление

  def update
    update_color
    update_text
    update_visibility
  end

  def update_color
    square.color = color
  end

  def update_text
    soldiers_text.text = soldiers
  end

  def update_visibility
    visible? ? soldiers_text.add : soldiers_text.remove
  end

  # Нажатие игроком 

  def clicked?(event)
    square.contains?(event.x, event.y) && !player_interface.typing_input?
  end

  def click
    

    if player_interface.selecting_target_cell?
      return unless adjacent_to_cell?(map.selected_cell)

      map.target_cell = self
      player_interface.typing_number_of_soldiers_to_move = true
      player_interface.selecting_target_cell = false
    elsif map.selected_cell == self
      map.selected_cell = nil
    else
      map.selected_cell = self
    end
  end

  # Характеристики

  def with_active_soldiers?
    active_soldiers > 0
  end
end