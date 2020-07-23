require "test_helper"

module RubyPoker
  class Hand
    module HandTypeJudgers
      class StraightTest < Test::Unit::TestCase
        def setup
          @create_card = lambda do |suit: nil, number: nil|
            suit ||= RubyPoker::SUITS.sample
            number ||= RubyPoker::NUMBERS.sample
            Card.new(suit: suit, number: number)
          end

          @create_cards = ->(args) { args.map { |suit, number| @create_card.(suit: suit, number: number) } }
          @call_judge = ->(args) { RubyPoker::Hand::HandTypeJudgers::Straight.judge(cards: @create_cards.(args)) }
        end

        test "match" do
          assert_not_nil(@call_judge.([
            [:spade, 9],
            [:club, 10],
            [:spade, 11],
            [:diamond, 12],
            [:spade, 13],
          ]))
        end

        test "match with ace" do
          assert_not_nil(@call_judge.([
            [:club, 10],
            [:spade, 11],
            [:diamond, 12],
            [:spade, 13],
            [:spade, 1],
          ]))
        end

        test "not match with ace" do
          assert_nil(@call_judge.([
            [:diamond, 1],
            [:club, 2],
            [:diamond, 3],
            [:diamond, 4],
            [:diamond, 5],
          ]))
        end

        test "wrong number" do
          assert_nil(@call_judge.([
            [:club, 10],
            [:spade, 12],
            [:diamond, 12],
            [:spade, 13],
            [:spade, 1],
          ]))
        end
      end
    end
  end
end
