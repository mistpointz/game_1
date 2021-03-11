require_relative 'helpers'

module PlayerInterfaces
  module UpdateMethods
    def update_elements
      if selected_cell&.visible?
        visible_cell_part_elements.each(&:add)
      else
        visible_cell_part_elements.each(&:remove)
      end

      if selected_cell&.player == human_player
        human_player_cell_part_elements.each(&:add)
      else
        human_player_cell_part_elements.each(&:remove)
      end

      if typing_input?
        cell_input_elements.each(&:add)
      else
        cell_input_elements.each(&:remove)
      end

      update_general_part
      update_cell_part
      update_buttons
    end

    def update_buttons
      buttons.each { |button| button.color = button.active? ? active_button_color : inactive_button_color }
    end

    def buttons
      [ increase_soldiers_level_button, increase_gold_income_level_button, next_turn_button,
        buy_soldier_button, buy_max_affordable_soldiers_button, move_soldiers_button, confirm_button ]
    end
  end
end