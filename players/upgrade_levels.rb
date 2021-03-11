module Players
  module UpgradeLevels
    def increase_soldiers_level_cost
      (10 + soldiers_level) * (10 + soldiers_level)
    end

    def increase_gold_income_level_cost
      (10 + gold_income_level) * (10 + gold_income_level)
    end

    def increase_gold_income_level
      @gold -= increase_gold_income_level_cost
      @gold_income_level += 1
    end

    def increase_soldiers_level
      @gold -= increase_soldiers_level_cost
      @soldiers_level += 1
    end
  end
end