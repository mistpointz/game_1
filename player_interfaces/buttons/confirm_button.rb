module PlayerInterfaces
  module Buttons
    class ConfirmButton < Base
      def active?
        player_interface.typing_input? && player_interface.cell_input_text.text.to_i.between?(1, map.selected_cell.active_soldiers)
      end

      def click
        if player_interface.typing_number_of_soldiers_to_move?
          player_interface.selected_cell.move_soldiers(map.target_cell, player_interface.cell_input_text.text.to_i)
        end

        player_interface.typing_number_of_soldiers_to_move = false
        map.target_cell = nil
        map.selected_cell = nil
      end
    end
  end
end