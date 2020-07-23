Dir[__dir__ + "/hand/hand_type_judgers/*.rb"].each { |p| require p }

module RubyPoker
  class Hand
    include Comparable

    attr_reader :hand_type, :comparison_card

    def initialize(cards:)
      raise(ArgumentError) if cards.size != 5
      @hand_type, @comparison_card = judge(cards: cards)
    end

    def hand_level
      RubyPoker::HAND_TYPES.reverse.index(@hand_type)
    end

    def <=>(other)
      hand_comparison = hand_level <=> other.hand_level
      hand_comparison.zero? ? @comparison_card <=> other.comparison_card : hand_comparison
    end

  private

    def judge(cards:)
      matched_cards = nil
      matched_type = RubyPoker::HAND_TYPES.find do |type|
        judger = RubyPoker::Hand::HandTypeJudgers.const_get(type.to_s.classify)
        matched_cards = judger.judge(cards: cards)
      end

      [matched_type, matched_cards.max]
    end
  end
end
