module Players
  module PlayerStatus
    def alive?
      player_cells.count > 0
    end

    def dead?
      !alive?
    end
  end
end