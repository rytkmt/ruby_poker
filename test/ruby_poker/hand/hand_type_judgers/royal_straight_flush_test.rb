require "test_helper"

module RubyPoker
  class Hand
    module HandTypeJudgers
      class RoyalStraightFlushTest < Test::Unit::TestCase
        def setup
          @create_card = lambda do |suit: nil, number: nil|
            suit ||= RubyPoker::SUITS.sample
            number ||= RubyPoker::NUMBERS.sample
            Card.new(suit: suit, number: number)
          end

          @create_cards = ->(args) { args.map { |suit, number| @create_card.(suit: suit, number: number) } }
          @call_judge = ->(args) { RubyPoker::Hand::HandTypeJudgers::RoyalStraightFlush.judge(cards: @create_cards.(args)) }
        end

        test "match spade" do
          assert_not_nil(@call_judge.([
            [:spade, 10],
            [:spade, 11],
            [:spade, 12],
            [:spade, 13],
            [:spade, 1],
          ]))
        end

        test "match diamond" do
          assert_not_nil(@call_judge.([
            [:diamond, 10],
            [:diamond, 11],
            [:diamond, 12],
            [:diamond, 13],
            [:diamond, 1],
          ]))
        end

        test "disparate suit" do
          assert_nil(@call_judge.([
            [:diamond, 10],
            [:heart, 11],
            [:diamond, 12],
            [:diamond, 13],
            [:diamond, 1],
          ]))
        end

        test "wrong number" do
          assert_nil(@call_judge.([
            [:diamond, 10],
            [:diamond, 11],
            [:diamond, 12],
            [:diamond, 13],
            [:diamond, 2],
          ]))
        end
      end
    end
  end
end
