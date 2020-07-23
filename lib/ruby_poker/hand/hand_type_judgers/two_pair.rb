module RubyPoker
  class Hand
    module HandTypeJudgers
      module TwoPair
        def self.judge(cards:)
          pairs = cards.group_by(&:number_level).select { |k, v| v.size == 2 }
          return nil unless pairs.size == 2
          pairs.max.second
        end
      end
    end
  end
end
