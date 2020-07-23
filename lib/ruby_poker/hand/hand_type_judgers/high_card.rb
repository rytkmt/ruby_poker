module RubyPoker
  class Hand
    module HandTypeJudgers
      module HighCard
        def self.judge(cards:)
          [cards.max]
        end
      end
    end
  end
end
