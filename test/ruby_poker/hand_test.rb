require "test_helper"

module RubyPoker
  class HandTest < Test::Unit::TestCase
    def setup
      @create_card = lambda do |suit: nil, number: nil|
        suit ||= RubyPoker::SUITS.sample
        number ||= RubyPoker::NUMBERS.sample
        Card.new(suit: suit, number: number)
      end
      @create_cards = ->(n) { n.times.map { @create_card.call } }
    end
    sub_test_case "#initialize" do
      test "wrong number of arguments" do
        assert_raise_kind_of(ArgumentError) do
          Hand.new(cards: @create_cards.(6))
        end
      end

      sub_test_case "#judge" do
        test "matched" do
          stub(RubyPoker::HandTypeJudgers::RoyalStraightFlush).judge { |cards:| cards[0..2] }
          hand = Hand.new(
            cards: [
              Card.new(suit: :spade, number: 6),
              Card.new(suit: :heart, number: 2),
              Card.new(suit: :diamond, number: 7),
              Card.new(suit: :spade, number: 10),
              Card.new(suit: :spade, number: 3)
            ]
          )
          assert_equal(:royal_straight_flush, hand.hand_type)
          assert_equal(:diamond, hand.comparison_card.suit)
          assert_equal(7, hand.comparison_card.number)
        end
      end
    end
  end
end
