Dir[__dir__ + "/hand_type_judgers/*.rb"].each { |p| require p }

module RubyPoker
  class Hand
    include Comparable

    attr_reader :hand_type, :comparison_card

    def initialize(cards:)
      raise(ArgumentError) if cards.size != 5
      @cards = cards
      @hand_type, @comparison_card = judge
    end

  private

    def judge
      matched_cards = nil
      matched_type = RubyPoker::HAND_TYPES.find do |type|
        judger = RubyPoker::HandTypeJudgers.const_get(type.to_s.classify)
        matched_cards = judger.judge(cards: @cards)
      end

      [matched_type, matched_cards.max]
    end
  end
end
