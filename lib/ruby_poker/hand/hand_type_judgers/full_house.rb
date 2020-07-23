module RubyPoker
  class Hand
    module HandTypeJudgers
      module FullHouse
        def self.judge(cards:)
          grouped_number_cards = cards.group_by(&:number)
          three_card_number, three_cards = grouped_number_cards.detect { |k, v| v.size == 3 }
          return nil unless three_card_number
          grouped_number_cards.delete(three_card_number)
          return nil unless grouped_number_cards.detect { |k, v| v.size == 2 }
          three_cards
        end
      end
    end
  end
end
