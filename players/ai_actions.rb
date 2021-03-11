module Players
  module AIActions
    MIN_SUFFICIENT_SUPERIORITY = 30
    ACCEPTABLE_RISK = 25

    def make_ai_turn
      move_internal_soldiers_to_cells_for_defense
      move_internal_soldiers_to_cells_for_attack
      move_internal_soldiers_to_borders_randomly

      buy_soldiers_for_defense

      move_border_soldiers_to_cells_for_defense
      move_border_soldiers_to_cells_for_attack

      safely_attack_possible_targets

      buy_soldiers_for_next_turn_attack
      randomly_reinforce_cells_ready_for_next_turn_attack
      buy_soldiers_to_random_cell_with_min_insufficient_soldiers_for_attack

      upgrade_levels

      @border_cells = nil
    end

    def safely_attack_possible_targets
      required_superiority = rand(MIN_SUFFICIENT_SUPERIORITY)

      border_cells.select(&:with_active_soldiers?).shuffle.each do |cell|
        target_cell = cell.random_target_cell_for_safe_attack(required_superiority)
        next unless target_cell

        cell.safely_attack_cell(target_cell, required_superiority)
        @border_cells = nil

        redo if cell.active_soldiers > 0
      end
    end

    def buy_soldiers_for_defense
      while gold >= Game::SOLDIER_COST
        cell = border_cells.select(&:insufficient_soldiers_for_defense?).shuffle.
          sort_by(&:soldiers_to_max_adjacent_enemy_soldiers).sample
        break unless cell

        cell.buy_one_soldier
      end
    end

    def upgrade_levels
      while gold >= increase_soldiers_level_cost do
        increase_soldiers_level
      end

      while gold >= increase_gold_income_level_cost do
        increase_gold_income_level
      end
    end

    def move_internal_soldiers_to_borders_randomly
      internal_cells.select(&:with_active_soldiers?).shuffle.each do |cell|
        nearest_border_cell = cell.random_nearest_border_cell
        break unless nearest_border_cell

        x_dir = (nearest_border_cell.x - cell.x) / (nearest_border_cell.x - cell.x).abs if nearest_border_cell.x != cell.x
        y_dir = (nearest_border_cell.y - cell.y) / (nearest_border_cell.y - cell.y).abs if nearest_border_cell.y != cell.y

        if nearest_border_cell.x != cell.x && nearest_border_cell.y != cell.y
          target_cell = (rand(2) == 0 ? map.cell(cell.x + x_dir, cell.y) : map.cell(cell.x, cell.y + y_dir))
        elsif nearest_border_cell.x != cell.x
          target_cell = map.cell(cell.x + x_dir, cell.y)
        else
          target_cell = map.cell(cell.x, cell.y + y_dir)
        end

        cell.move_soldiers(target_cell, cell.active_soldiers)
      end
    end

    # Купить солдат в клетки для атаки на следующем ходу
    def buy_soldiers_for_next_turn_attack
      border_cells.select(&:insufficient_soldiers_for_attack?).shuffle.sort_by(&:insufficient_soldiers_for_attack).each do |cell|
        cell.buy_soldiers(cell.insufficient_soldiers_for_attack) if max_affordable_soldiers >= cell.insufficient_soldiers_for_attack
      end
    end

    # Купить солдат на все деньги в случайную клетку из максимально близких к возможности атаки
    def buy_soldiers_to_random_cell_with_min_insufficient_soldiers_for_attack
      cell = border_cells.select(&:insufficient_soldiers_for_attack?).shuffle.sort_by(&:insufficient_soldiers_for_attack).first
      return unless cell

      cell.buy_soldiers(max_affordable_soldiers)
    end

    # Случайным образом усилить клетки, готовые для атаки на следующем ходу
    def randomly_reinforce_cells_ready_for_next_turn_attack
      while gold >= Game::SOLDIER_COST do
        cell = border_cells.select(&:sufficient_soldiers_for_attack?).sample
        break unless cell

        cell.buy_one_soldier
      end
    end

    # Переместить внутренних солдат в соседние клетки, которые недостаточно защищены
    def move_internal_soldiers_to_cells_for_defense
      move_soldiers_to_cells(:random_adjacent_player_cell_with_insufficient_soldiers_for_defense, :internal?)
    end

    # Переместить внутренних солдат в соседние клетки, более подходящие для атаки
    def move_internal_soldiers_to_cells_for_attack
      move_soldiers_to_cells(:random_adjacent_player_cell_with_min_insufficient_soldiers_for_attack, :internal?)
    end

    # Переместить граничных солдат в соседние клетки, которые недостаточно защищены
    def move_border_soldiers_to_cells_for_defense
      move_soldiers_to_cells(:random_adjacent_player_cell_with_insufficient_soldiers_for_defense, :adjacent_to_foreign?)
    end

    # Переместить граничных солдат в соседние клетки, более подходящие для атаки
    def move_border_soldiers_to_cells_for_attack
      move_soldiers_to_cells(:random_adjacent_player_cell_with_min_insufficient_soldiers_for_attack, :adjacent_to_foreign?)
    end

    def move_soldiers_to_cells(target_cell_selection_method, cells_selection_method)
      player_cells.select(&:with_active_soldiers?).select(&cells_selection_method).shuffle.each do |cell|
        target_cell = cell.public_send(target_cell_selection_method)

        next unless target_cell
        next if cell.adjacent_to_foreign? && cell.insufficient_soldiers_for_attack <= target_cell.insufficient_soldiers_for_attack
        next unless cell.can_safely_move_soldiers?(target_cell)

        cell.safely_move_soldiers(target_cell)
      end
    end
  end
end