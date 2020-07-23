module RubyPoker
  class Hand
    module HandTypeJudgers
      module RoyalStraightFlush
        def self.judge(cards:)
          return nil unless cards.map(&:suit).uniq.size == 1
          return nil unless cards.sort.map(&:number) == [10, 11, 12, 13, 1]
          cards
        end
      end
    end
  end
end
