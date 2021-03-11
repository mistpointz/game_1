module Cells
  module CellProperties
    def occupied?
      !player.nil?
    end

    def unoccupied?
      !occupied?
    end

    def adjacent_to_player?(player)
      adjacent_cells.any? { |cell| cell.player == player }
    end

    def adjacent_to_foreign?
      adjacent_foreign_cells.count > 0
    end

    def internal?
      !adjacent_to_foreign?
    end

    def visible?
      adjacent_to_player?(human_player) || player == human_player || human_player.dead?
    end

    def fogged?
      !visible?
    end
  end
end