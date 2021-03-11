module Cells
  module CellsRelations
    def adjacent_cells
      @adjacent_cells ||= [ map.cell(x - 1, y), map.cell(x + 1, y), map.cell(x, y - 1), map.cell(x, y + 1) ].compact
    end

    def adjacent_player_cells
      adjacent_cells.select { |cell| cell.player == player }
    end

    def adjacent_foreign_cells
      adjacent_cells.select { |cell| cell.player != player }
    end

    def adjacent_enemy_cells
      adjacent_foreign_cells.select(&:occupied?)
    end

    def adjacent_border_cells
      adjacent_player_cells & player.border_cells
    end

    def adjacent_to_cell?(cell)
      distance_to_cell(cell) == 1
    end



    # Расстояние до клетки
    def distance_to_cell(cell)
      (cell.x - x).abs + (cell.y - y).abs
    end
  end
end