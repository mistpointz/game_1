module PlayerInterfaces
  module Buttons
    class Base
      attr_reader :shape, :player_interface

      def initialize(shape, player_interface)
        @shape = shape
        @player_interface = player_interface
        @visible = true
      end

      def clicked?(event)
        shape.contains?(event.x, event.y) && active? && visible?
      end

      # Изменение кнопки

      def add
        shape.add
        @visible = true
      end

      def remove
        shape.remove
        @visible = false
      end

      def color=(color)
        shape.color = color
      end

      # Вспомогательные методы

      def game
        player_interface.game
      end

      def map
        game.map
      end

      def selected_cell
        map.selected_cell
      end

      def human_player
        game.human_player
      end

      # Состояние кнопки

      def active?
        false
      end

      def visible?
        @visible
      end
    end
  end
end