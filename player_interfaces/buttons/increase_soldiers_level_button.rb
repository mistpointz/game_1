module PlayerInterfaces
  module Buttons
    class IncreaseSoldiersLevelButton < Base
      def active?
        human_player.gold >= human_player.increase_soldiers_level_cost && !player_interface.selecting_target_cell? &&
          !player_interface.typing_input?
      end

      def click
        human_player.increase_soldiers_level
      end
    end
  end
end