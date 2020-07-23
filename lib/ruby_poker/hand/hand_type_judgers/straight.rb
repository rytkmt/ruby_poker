module RubyPoker
  class Hand
    module HandTypeJudgers
      module Straight
        def self.judge(cards:)
          min_number_level = cards.min.number_level
          expected = [*min_number_level..min_number_level + 4]
          return nil unless cards.sort.map(&:number_level) == expected
          cards
        end
      end
    end
  end
end
