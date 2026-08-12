# frozen_string_literal: true

require_relative 'constants/af'

module Humanize
  class Af
    def humanize(number)
      iteration = 0
      parts = []
      use_and = false
      until number.zero?
        number, remainder = number.divmod(1000)
        unless remainder.zero?
          if iteration.zero? && remainder < 100
            use_and = true
          else
            add_grouping(parts, use_and, iteration, remainder)
          end

          # Only add the SUB_ONE_GROUPING if it is NOT the special "eenduisend" case
          unless iteration == 1 && remainder.between?(1, 9)
            parts << SUB_ONE_GROUPING[remainder]
          end
        end

        iteration += 1
      end

      parts
    end

    private

    def conjunction(parts, use_and)
      return '' if parts.empty? || !use_and
      ' en'
    end

    def add_grouping(parts, use_and, iteration, remainder)
      grouping = LOTS[iteration]
      return unless grouping
    
      if iteration == 1 && remainder.between?(1, 9)
        # Compound the number with "duisend" → eenduisend, tweeduisend, etc.
        compound = "#{SUB_ONE_GROUPING[remainder]}#{grouping}"
        parts << "#{compound}#{conjunction(parts, use_and)}"
      else
        parts << "#{grouping}#{conjunction(parts, use_and)}"
      end
    end
  end
end