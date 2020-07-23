module RubyPoker
  class Hand
    module HandTypeJudgers
      module Flush
        def self.judge(cards:)
          return nil unless cards.map(&:suit).uniq.size == 1
          cards
        end
      end
    end
  end
end
