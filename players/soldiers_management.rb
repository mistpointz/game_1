module Players
  module SoldiersManagement
    def max_affordable_soldiers
      gold / Game::SOLDIER_COST
    end

    def max_affordable_soldiers_cost
      max_affordable_soldiers * Game::SOLDIER_COST
    end
  end
end