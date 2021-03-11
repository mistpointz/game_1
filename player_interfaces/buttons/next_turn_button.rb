module PlayerInterfaces
  module Buttons
    class NextTurnButton < Base
      def active?
        !player_interface.selecting_target_cell? && !player_interface.typing_input?
      end

      def click
        game.make_turn
      end
    end
  end
end