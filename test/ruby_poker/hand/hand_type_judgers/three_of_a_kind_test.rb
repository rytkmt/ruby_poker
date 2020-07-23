require "test_helper"

module RubyPoker
  class Hand
    module HandTypeJudgers
      class ThreeOfAKindTest < Test::Unit::TestCase
        def setup
          @create_card = lambda do |suit: nil, number: nil|
            suit ||= RubyPoker::SUITS.sample
            number ||= RubyPoker::NUMBERS.sample
            Card.new(suit: suit, number: number)
          end

          @create_cards = ->(args) { args.map { |suit, number| @create_card.(suit: suit, number: number) } }
          @call_judge = ->(args) { RubyPoker::Hand::HandTypeJudgers::ThreeOfAKind.judge(cards: @create_cards.(args)) }
        end

        test "match" do
          assert_not_nil(@call_judge.([
            [:spade, 10],
            [:heart, 10],
            [:club, 10],
            [:diamond, 9],
            [:spade, 1],
          ]))
        end

        test "not match" do
          assert_nil(@call_judge.([
            [:spade, 11],
            [:heart, 10],
            [:club, 10],
            [:diamond, 9],
            [:spade, 1],
          ]))
        end
      end
    end
  end
end
