# frozen_string_literal: true

class Player
  include Players::PlayerStatus
  include Players::Cells
  include Players::UpgradeLevels
  include Players::SoldiersManagement
  include Players::AIActions

  attr_reader :map, :name, :color, :soldiers_level, :gold_income_level
  attr_accessor :gold

  # Инициализация

  def initialize(map, name, color)
    @map = map
    @color = color
    @gold = 0

    @soldiers_level = 0
    @gold_income_level = 0
  end

  # Ежеходные изменения

  def increase_gold
    @gold += rand(player_cells.count * (Game::CELL_BASE_INCOME + gold_income_level))
  end
end