module RubyPoker
  class Hand
    module HandTypeJudgers
      module OnePair
        def self.judge(cards:)
          cards.group_by(&:number_level).detect { |k, v| v.size == 2 }&.second
        end
      end
    end
  end
end
