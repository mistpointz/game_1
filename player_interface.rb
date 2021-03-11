# frozen_string_literal: true

class PlayerInterface
  include PlayerInterfaces::Helpers
  include PlayerInterfaces::CellPart
  include PlayerInterfaces::GeneralPart
  include PlayerInterfaces::UpdateMethods
  include PlayerInterfaces::PlayerState

  attr_reader :game

  # Инициализация

  def initialize(game)
    @game = game

    initialize_general_part
    initialize_cell_part
  end
end