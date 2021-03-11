# frozen_string_literal: true

class Map
  attr_reader :game, :cells
  attr_accessor :selected_cell, :target_cell

  SIZE = 10

  # Инициализация

  def initialize(game)
    @game = game
    @cells = []

    SIZE.times do |x|
      SIZE.times do |y|
        @cells << Cell.new(self, x, y)
      end
    end
  end

  # Обновление

  def update
    update_cells
  end

  # Клетки

  def cell(x, y)
    cells.find { |cell| cell.x == x && cell.y == y }
  end

  def unoccupied_cells
    cells.select(&:unoccupied?)
  end

  private

  def update_cells
    cells.each(&:update)
  end
end