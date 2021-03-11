require_relative 'helpers'

module PlayerInterfaces
  module CellPart
    attr_reader :cell_soldiers_text, :buy_soldier_button, :buy_soldier_text, :buy_max_affordable_soldiers_button,
      :buy_max_affordable_soldiers_text, :move_soldiers_button, :move_soldiers_text, :cell_prompt_text,
      :cell_input_text, :confirm_button, :confirm_text, :cell_input_rectangle

    CELL_PART_TOP_BORDER = 250

    # Константы

    def cell_part_top_border
      CELL_PART_TOP_BORDER
    end

    # Инициализация

    def initialize_cell_part
      initialize_soldiers_management_part
      initialize_cell_actions_buttons
      initialize_cell_prompt_text
      initialize_cell_input_text
    end

    def initialize_soldiers_management_part
      @cell_soldiers_text = Text.new("", x: left_border, y: cell_part_top_border, size: text_size, z: 10, color: text_color)

      @buy_soldier_button = Buttons::BuySoldierButton.new(
        Circle.new(x: left_border + 300, y: cell_part_top_border + 11, radius: 10, sectors: 32, color: 'yellow', z: 8), self)
      @buy_soldier_text = Text.new("+   #{Game::SOLDIER_COST}g", x: left_border + 294, y: cell_part_top_border, size: text_size, z: 10, color: text_color)

      @buy_max_affordable_soldiers_button = Buttons::BuyMaxSoldiersButton.new(
        Circle.new(x: left_border + 400, y: cell_part_top_border + 11, radius: 10, sectors: 32, color: 'yellow', z: 8), self)
      @buy_max_affordable_soldiers_text = Text.new("", x: left_border + 394, y: cell_part_top_border, size: text_size, z: 10, color: text_color)
    end

    def initialize_cell_actions_buttons
      @move_soldiers_button = Buttons::MoveSoldiersButton.new(
        Rectangle.new(x: left_border, y: cell_part_top_border + 60, width: 200, height: 40, color: 'yellow', z: 10), self)
      @move_soldiers_text = Text.new("Move soldiers", x: left_border + 40, y: cell_part_top_border + 69, size: text_size, z: 10, color: text_color)    
    end

    def initialize_cell_prompt_text
      @cell_prompt_text = Text.new("", x: left_border, y: cell_part_top_border + 220, size: 20, z: 10, color: text_color)
    end

    def initialize_cell_input_text
      @cell_input_rectangle = Rectangle.new(x: left_border + 250, y: cell_part_top_border + 60, width: 200, height: 40, color: 'purple', z: 8)
      @cell_input_text = Text.new("", x: left_border + 260, y: cell_part_top_border + 68, size: 20, z: 10, color: 'yellow')

      @confirm_button = Buttons::ConfirmButton.new(
        Rectangle.new(x: 550, y: 360, width: 200, height: 40, color: 'yellow', z: 10), self)
      @confirm_text = Text.new("Confirm", x: 560, y: 368, size: 20, z: 10, color: 'black')
    end

    # Обновление

    def update_cell_part
      update_soldiers_management_part
      update_cell_prompt_text
      update_cell_input_text
    end

    def update_soldiers_management_part
      cell_soldiers_text.text = 
        if selected_cell&.player == human_player
          "Армия клетки: #{selected_cell&.active_soldiers} / #{selected_cell&.soldiers}"
        elsif selected_cell&.player.nil?
          "Варвары: #{selected_cell&.soldiers}"
        else
          "Армия клетки: #{selected_cell&.soldiers}"
        end

      buy_max_affordable_soldiers_text.text = "+   max (#{human_player.max_affordable_soldiers})  #{human_player.max_affordable_soldiers_cost}g"
    end

    def update_cell_prompt_text
      cell_prompt_text.text =
        if typing_number_of_soldiers_to_move?
          "Введите количество солдат для перемещения"
        elsif selecting_target_cell?
          "Выберите клетку, в которую хотите переместить солдат"
        else
          ""
        end
    end

    def update_cell_input_text
      cell_input_text.text = "" unless typing_number_of_soldiers_to_move?
    end

    # Наборы элементов интерфейса

    def visible_cell_part_elements
      [ cell_soldiers_text ]
    end

    def human_player_cell_part_elements
      [ buy_soldier_text, buy_soldier_button,
        buy_max_affordable_soldiers_text, move_soldiers_button, move_soldiers_text, buy_max_affordable_soldiers_button ]
    end

    def cell_input_elements
      [ cell_input_text, cell_input_rectangle, confirm_button, confirm_text ]
    end
  end
end