module PlayerInterfaces
  module Buttons
    class BuySoldierButton < Base
      def active?
        human_player.gold >= Game::SOLDIER_COST && !player_interface.selecting_target_cell? &&
          !player_interface.typing_input?
      end

      def click
        selected_cell.buy_one_soldier
      end
    end
  end
end