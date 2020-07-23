require "test_helper"

module RubyPoker
  class Hand
    module HandTypeJudgers
      class StraightFlushTest < Test::Unit::TestCase
        def setup
          @create_card = lambda do |suit: nil, number: nil|
            suit ||= RubyPoker::SUITS.sample
            number ||= RubyPoker::NUMBERS.sample
            Card.new(suit: suit, number: number)
          end

          @create_cards = ->(args) { args.map { |suit, number| @create_card.(suit: suit, number: number) } }
          @call_judge = ->(args) { RubyPoker::Hand::HandTypeJudgers::StraightFlush.judge(cards: @create_cards.(args)) }
        end

        test "match spade" do
          assert_not_nil(@call_judge.([
            [:spade, 9],
            [:spade, 10],
            [:spade, 11],
            [:spade, 12],
            [:spade, 13],
          ]))
        end

        test "match diamond" do
          assert_not_nil(@call_judge.([
            [:diamond, 2],
            [:diamond, 3],
            [:diamond, 4],
            [:diamond, 5],
            [:diamond, 6],
          ]))
        end

        test "disparate suit" do
          assert_nil(@call_judge.([
            [:diamond, 2],
            [:club, 3],
            [:diamond, 4],
            [:diamond, 5],
            [:diamond, 6],
          ]))
        end

        test "wrong number" do
          assert_nil(@call_judge.([
            [:diamond, 1],
            [:diamond, 2],
            [:diamond, 3],
            [:diamond, 4],
            [:diamond, 5],
          ]))
        end
      end
    end
  end
end
