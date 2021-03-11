require_relative 'helpers'

module PlayerInterfaces
  module GeneralPart
    attr_reader :current_turn_text, :gold_text
    attr_reader :soldiers_level_text, :gold_income_level_text, :increase_soldiers_level_cost_text,
      :increase_gold_income_level_cost_text
    attr_reader :increase_soldiers_level_button, :increase_gold_income_level_button, :next_turn_button

    GENERAL_PART_TOP_BORDER = 40

    # Константы

    def general_part_top_border
      GENERAL_PART_TOP_BORDER
    end

    # Инициализация

    def initialize_general_part
      initialize_general_info_part
      initialize_levels_part
      initialize_general_buttons
    end

    def initialize_general_info_part
      @current_turn_text = Text.new("", x: left_border, y: general_part_top_border, size: text_size, z: 10, color: text_color)
      @gold_text = Text.new("", x: left_border, y: general_part_top_border + 30, size: text_size, z: 10, color: text_color)
    end

    def initialize_levels_part
      @soldiers_level_text = Text.new("", x: left_border, y: general_part_top_border + 90, size: text_size, z: 10, color: text_color)
      @increase_soldiers_level_button = Buttons::IncreaseSoldiersLevelButton.new(
        Circle.new(x: 850, y: general_part_top_border + 102, radius: 10, sectors: 32, color: 'yellow', z: 10), self)
      @increase_soldiers_level_cost_text = Text.new("", x: 844, y: general_part_top_border + 90, size: text_size, z: 10, color: text_color)

      @gold_income_level_text = Text.new("", x: left_border, y: general_part_top_border + 120, size: text_size, z: 10, color: text_color)
      @increase_gold_income_level_button = Buttons::IncreaseGoldIncomeLevelButton.new(
        Circle.new(x: 850, y: general_part_top_border + 132, radius: 10, sectors: 32, color: 'yellow', z: 10), self)
      @increase_gold_income_level_cost_text = Text.new("", x: 844, y: general_part_top_border + 120, size: text_size, z: 10, color: text_color)
    end

    def initialize_general_buttons
      @next_turn_button = Buttons::NextTurnButton.new(
        Rectangle.new(x: 550, y: 410, width: 200, height: 40, color: 'yellow', z: 10), self)
      Text.new("Next turn", x: 610, y: 419, size: 20, z: 10, color: 'black')
    end

    # Обновление

    def update_general_part
      update_general_info_part
      update_levels_part
    end

    def update_general_info_part
      current_turn_text.text = "Current turn: #{game.current_turn}"
      gold_text.text = "Gold: #{human_player.gold}g"
    end

    def update_levels_part
      soldiers_level_text.text = "Уровень солдат: #{human_player.soldiers_level}"
      gold_income_level_text.text = "Уровень прироста золота: #{human_player.gold_income_level}"

      increase_soldiers_level_cost_text.text = "+   #{human_player.increase_soldiers_level_cost}g"
      increase_gold_income_level_cost_text.text = "+   #{human_player.increase_gold_income_level_cost}g"
    end
  end
end