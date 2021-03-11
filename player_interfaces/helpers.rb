module PlayerInterfaces
  module Helpers
    LEFT_BORDER = 550

    TEXT_SIZE = 20
    TEXT_COLOR = 'black'

    ACTIVE_BUTTON_COLOR = 'yellow'
    INACTIVE_BUTTON_COLOR = '#666666'

    def selected_cell
      game.map.selected_cell
    end

    def human_player
      game.human_player
    end

    def left_border
      LEFT_BORDER
    end

    def text_size
      TEXT_SIZE
    end

    def text_color
      TEXT_COLOR
    end

    def active_button_color
      ACTIVE_BUTTON_COLOR
    end

    def inactive_button_color
      INACTIVE_BUTTON_COLOR
    end
  end
end