module Cells
  module SoldiersActions
    def move_soldiers(target_cell, soldiers_count)
      if target_cell.player == player
        move_soldiers_to_player_cell(target_cell, soldiers_count)
      else
        attack_enemy_cell(target_cell, soldiers_count)
      end
    end
  
    def move_soldiers_to_player_cell(target_cell, soldiers_count)
      self.active_soldiers -= soldiers_count
      self.soldiers -= soldiers_count

      target_cell.soldiers += soldiers_count
    end

    def attack_enemy_cell(target_cell, soldiers_count)
      enemy = target_cell.player

      soldiers_left = soldiers_count
      enemy_soldiers_left = target_cell.soldiers

      10.times do
        enemy_damage = enemy_soldiers_left / 100.0 * rand(10 + enemy&.soldiers_level.to_i)
        soldiers_left -= enemy_damage
        break if soldiers_left <= 0

        damage = soldiers_left / 100.0 * rand(10 + player.soldiers_level)
        enemy_soldiers_left -= damage
        break if enemy_soldiers_left <= 0
      end

      soldiers_left = [soldiers_left.round, 0].max
      enemy_soldiers_left = [enemy_soldiers_left.round, 0].max

      if soldiers_left > 0 && enemy_soldiers_left == 0
        target_cell.player = player
        target_cell.soldiers = soldiers_left
        target_cell.active_soldiers = 0

        self.soldiers -= soldiers_count
      else
        target_cell.soldiers = enemy_soldiers_left
        target_cell.active_soldiers = rand([target_cell.active_soldiers, enemy_soldiers_left].min + 1)

        self.soldiers -= (soldiers_count - soldiers_left)
      end

      self.active_soldiers -= soldiers_count
    end
  end
end

