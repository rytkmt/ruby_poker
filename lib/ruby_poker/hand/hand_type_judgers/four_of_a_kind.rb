module RubyPoker
  class Hand
    module HandTypeJudgers
      module FourOfAKind
        def self.judge(cards:)
          cards.group_by(&:number).detect { |k, v| v.size == 4 }&.second
        end
      end
    end
  end
end
