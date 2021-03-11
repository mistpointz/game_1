module Cells
  module AIAnalysis
    # Случайная ближайшая граничная клетка
    def random_nearest_border_cell
      player.border_cells.select { |cell| distance_to_cell(cell) == distance_to_nearest_border_cell }.sample
    end

    # Расстояние до ближайшей граничной клетки
    def distance_to_nearest_border_cell
      player.border_cells.map(&method(:distance_to_cell)).min
    end



    # Достаточно солдат для защиты клетки?
    def sufficient_soldiers_for_defense?
      insufficient_soldiers_for_defense == 0
    end

    # Недостаточно солдат для защиты клетки?
    def insufficient_soldiers_for_defense?
      !sufficient_soldiers_for_defense?
    end

    # Недостающее количество солдат для защиты
    def insufficient_soldiers_for_defense
      [max_adjacent_enemy_soldiers - soldiers, 0].max
    end

    # Докупить недостающее количество солдат для защиты
    def buy_soldiers_for_defense
      buy_soldiers([insufficient_soldiers_for_defense, player.max_affordable_soldiers].min)
    end

    # Максимальное количество вражеских солдат в соседней клетке
    def max_adjacent_enemy_soldiers(without: nil)
      (adjacent_enemy_cells - [without]).map(&:soldiers).max.to_i
    end



    # Относительно безопасное количество солдат для перемещения
    def safe_number_of_soldiers_to_move(target_cell)
      potential_soldiers = soldiers + player.max_affordable_soldiers
      affordable_soldiers_to_move = [(potential_soldiers / 100.0 * Player::ACCEPTABLE_RISK).round, 1].min
      result = [potential_soldiers - max_adjacent_enemy_soldiers(without: target_cell), affordable_soldiers_to_move].max

      [result, active_soldiers].min
    end

    # Переместить солдат с докупкой для защиты
    def safely_move_soldiers(target_cell)
      soldiers_count = safe_number_of_soldiers_to_move(target_cell)
      move_soldiers(target_cell, soldiers_count)
      buy_soldiers_for_defense
    end



    # Необходимое количество солдат для атаки с данным превосходством
    def required_active_soldiers_to_attack_cell(target_cell, required_superiority)
      return 1 if target_cell.soldiers == 0

      (target_cell.soldiers * (100 + required_superiority) / 100.0).ceil
    end

    # Безопасно атаковать клетку
    def safely_attack_cell(target_cell, required_superiority)
      required_soldiers = required_active_soldiers_to_attack_cell(target_cell, required_superiority)
      safe_soldiers = safe_number_of_soldiers_to_move(target_cell)

      self.active_soldiers -= required_soldiers
      self.soldiers -= required_soldiers
      temp = target_cell.soldiers
      target_cell.soldiers = 0

      soldiers_count = 
        if (adjacent_foreign_cells - [target_cell]).find { |cell| can_safely_attack_cell?(cell, required_superiority) }
          required_soldiers
        else
          safe_soldiers
        end

      self.active_soldiers += required_soldiers
      self.soldiers += required_soldiers
      target_cell.soldiers = temp

      move_soldiers(target_cell, soldiers_count)
      buy_soldiers_for_defense
      target_cell.buy_soldiers_for_defense if target_cell.player == player
    end



    def random_target_cell_for_safe_attack(required_superiority)
      adjacent_foreign_cells.select { |cell| can_safely_attack_cell?(cell, required_superiority) }.sample
    end

    def can_safely_attack_cell?(target_cell, required_superiority)
      safe_number_of_soldiers_to_move(target_cell) >=
        required_active_soldiers_to_attack_cell(target_cell, required_superiority)
    end

    def can_safely_move_soldiers?(target_cell)
      safe_number_of_soldiers_to_move(target_cell) > 0
    end



    # Наименьшее недостающее количество солдат для атаки в своей соседней клетке
    def min_adjacent_player_insufficient_soldiers_for_attack
      adjacent_border_cells.map(&:insufficient_soldiers_for_attack).min
    end

    # Случайная своя соседняя клетка с минимальным недостающим количеством солдат для атаки
    def random_adjacent_player_cell_with_min_insufficient_soldiers_for_attack
      adjacent_border_cells.select { |cell| cell.insufficient_soldiers_for_attack == min_adjacent_player_insufficient_soldiers_for_attack }.sample
    end



    # Случайная своя соседняя клетка с недостающим количеством солдат для защиты
    def random_adjacent_player_cell_with_insufficient_soldiers_for_defense
      adjacent_border_cells.select(&:insufficient_soldiers_for_defense?).shuffle.
        sort_by(&:soldiers_to_max_adjacent_enemy_soldiers).first
    end

    def soldiers_to_max_adjacent_enemy_soldiers
      soldiers / max_adjacent_enemy_soldiers.to_f
    end



    # Минимальное количество солдат в клетке, которое считается достаточным для атаки
    def min_sufficient_soldiers_for_attack
      return 1 if min_adjacent_foreign_soldiers == 0

      (min_adjacent_foreign_soldiers * (100 + Player::MIN_SUFFICIENT_SUPERIORITY) / 100.0).ceil
    end

    # Наименьшее количество солдат в не своей соседней клетке
    def min_adjacent_foreign_soldiers
      adjacent_foreign_cells.map(&:soldiers).min
    end

    # Недостающее количество солдат в клетке до минимального необходимого для атаки
    def insufficient_soldiers_for_attack
      [min_sufficient_soldiers_for_attack - soldiers, 0].max
    end

    def sufficient_soldiers_for_attack?
      insufficient_soldiers_for_attack == 0
    end

    def insufficient_soldiers_for_attack?
      !sufficient_soldiers_for_attack?
    end
  end
end