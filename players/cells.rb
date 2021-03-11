module Players
  module Cells
    def cells
      map.cells
    end

    def player_cells
      cells.select { |cell| cell.player == self }
    end

    def border_cells
      @border_cells ||= player_cells.select(&:adjacent_to_foreign?)
    end

    def internal_cells
      player_cells.select(&:internal?)
    end

    def adjacent_cells
      cells.select { |cell| cell.player != self && cell.adjacent_to_player?(self) }
    end
  end
end