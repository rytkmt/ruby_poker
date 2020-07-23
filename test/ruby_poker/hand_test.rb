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
      @create_hand = -> { Hand.new(cards: @create_cards.(5)) }
      @stub_hand = ->(result) {
        any_instance_of(RubyPoker::Hand) do |klass|
          stub(klass).judge { result }
        end
      }
    end
    sub_test_case "#initialize" do
      test "wrong number of arguments" do
        assert_raise_kind_of(ArgumentError) do
          Hand.new(cards: @create_cards.(6))
        end
      end

      sub_test_case "#judge" do
        test "matched" do
          stub(RubyPoker::Hand::HandTypeJudgers::RoyalStraightFlush).judge { |cards:| cards[0..2] }
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

    sub_test_case "#<=>" do
      sub_test_case "compare hand_type" do
        test "royal_straight_flush and flush" do
          @stub_hand.([:royal_straight_flush, Card.new(suit: :spade, number: 13) ])
          hand_a = @create_hand.call
          @stub_hand.([:flush, Card.new(suit: :spade, number: 13) ])
          hand_b = @create_hand.call

          assert(hand_a > hand_b)
        end

        test "full_house and two_pair" do
          @stub_hand.([:two_pair, Card.new(suit: :spade, number: 13) ])
          hand_a = @create_hand.call
          @stub_hand.([:full_house, Card.new(suit: :spade, number: 13) ] )
          hand_b = @create_hand.call

          assert(hand_a < hand_b)
        end

        test "max hand" do
          hands = []
          @stub_hand.([:two_pair, Card.new(suit: :spade, number: 13) ])
          hands << @create_hand.call
          @stub_hand.([:flush, Card.new(suit: :spade, number: 13) ])
          hands << @create_hand.call
          @stub_hand.([:straight, Card.new(suit: :spade, number: 13) ])
          hands << @create_hand.call
          @stub_hand.([:straight_flush, Card.new(suit: :spade, number: 13) ])
          hands << @create_hand.call

          assert_equal(:straight_flush, hands.max.hand_type)
        end

        sub_test_case "compare comparison_card(same hand_type)" do
          test "compare numbers" do
            @stub_hand.([:flush, Card.new(suit: :spade, number: 12) ])
            hand_a = @create_hand.call
            @stub_hand.([:flush, Card.new(suit: :spade, number: 13) ])
            hand_b = @create_hand.call

            assert(hand_a < hand_b)
          end

          test "compare ace" do
            @stub_hand.([:flush, Card.new(suit: :spade, number: 1) ])
            hand_a = @create_hand.call
            @stub_hand.([:flush, Card.new(suit: :spade, number: 13) ])
            hand_b = @create_hand.call

            assert(hand_a > hand_b)
          end

          test "compare suit" do
            @stub_hand.([:flush, Card.new(suit: :heart, number: 1) ])
            hand_a = @create_hand.call
            @stub_hand.([:flush, Card.new(suit: :club, number: 1) ])
            hand_b = @create_hand.call

            assert(hand_a > hand_b)
          end
        end
      end
    end
  end
end
