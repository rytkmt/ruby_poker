module RubyPoker
  class Hand
    module HandTypeJudgers
      module StraightFlush
        def self.judge(cards:)
          return nil unless cards.map(&:suit).uniq.size == 1
          min_number_level = cards.min.number_level
          expected = [*min_number_level..min_number_level + 4]
          return nil unless cards.sort.map(&:number_level) == expected
          cards
        end
      end
    end
  end
end
