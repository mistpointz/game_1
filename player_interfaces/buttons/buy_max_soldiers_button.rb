module PlayerInterfaces
  module Buttons
    class BuyMaxSoldiersButton < Base
      def active?
        human_player.gold >= Game::SOLDIER_COST && !player_interface.selecting_target_cell? &&
          !player_interface.typing_input?
      end

      def click
        selected_cell.buy_max_affordable_soldiers
      end
    end
  end
end