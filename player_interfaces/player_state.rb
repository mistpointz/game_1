module PlayerInterfaces
  module PlayerState
    attr_accessor :selecting_target_cell, :typing_number_of_soldiers_to_move

    alias_method :selecting_target_cell?, :selecting_target_cell
    alias_method :typing_number_of_soldiers_to_move?, :typing_number_of_soldiers_to_move

    def typing_input?
      typing_number_of_soldiers_to_move?
    end
  end
end