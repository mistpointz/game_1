module Cells
  module SoldiersManagement
    def buy_soldiers(soldiers_count)
      @soldiers += soldiers_count
      player.gold -= Game::SOLDIER_COST * soldiers_count
    end

    def buy_one_soldier
      buy_soldiers(1)
    end

    def buy_max_affordable_soldiers
      buy_soldiers(player.max_affordable_soldiers)
    end
  end
end

