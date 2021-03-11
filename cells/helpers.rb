module Cells
  module Helpers
    def game
      map.game
    end

    def human_player
      game.human_player
    end

    def player_interface
      game.player_interface
    end
  end
end