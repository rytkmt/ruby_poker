module RubyPoker
  class Hand
    module HandTypeJudgers
      module ThreeOfAKind
        def self.judge(cards:)
          cards.group_by(&:number).detect { |k, v| v.size == 3 }&.second
        end
      end
    end
  end
end
