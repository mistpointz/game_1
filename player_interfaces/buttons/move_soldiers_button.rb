module PlayerInterfaces
  module Buttons
    class MoveSoldiersButton < Base
      def active?
        map.selected_cell && map.selected_cell.active_soldiers > 0 && !player_interface.selecting_target_cell? &&
          !player_interface.typing_input?
      end

      def click
        player_interface.selecting_target_cell = true
      end
    end
  end
end