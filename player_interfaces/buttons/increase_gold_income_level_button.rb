module PlayerInterfaces
  module Buttons
    class IncreaseGoldIncomeLevelButton < Base
      def active?
        human_player.gold >= human_player.increase_gold_income_level_cost && !player_interface.selecting_target_cell? &&
          !player_interface.typing_input?
      end

      def click
        human_player.increase_gold_income_level
      end
    end
  end
end