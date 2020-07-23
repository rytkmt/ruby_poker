require "test_helper"

module RubyPoker
  class Hand
    module HandTypeJudgers
      class HighCardTest < Test::Unit::TestCase
        def setup
          @create_card = lambda do |suit: nil, number: nil|
            suit ||= RubyPoker::SUITS.sample
            number ||= RubyPoker::NUMBERS.sample
            Card.new(suit: suit, number: number)
          end

          @create_cards = ->(args) { args.map { |suit, number| @create_card.(suit: suit, number: number) } }
          @call_judge = ->(args) { RubyPoker::Hand::HandTypeJudgers::HighCard.judge(cards: @create_cards.(args)) }
        end

        test "result notincluding ace" do
          result = @call_judge.([
            [:spade, 10],
            [:heart, 11],
            [:club, 9],
            [:diamond, 12],
            [:spade, 4],
          ])
          assert_equal(1, result.size)
          assert_equal(12, result.first.number)
        end

        test "result including ace" do
          result = @call_judge.([
            [:spade, 10],
            [:heart, 11],
            [:club, 9],
            [:diamond, 12],
            [:spade, 1],
          ])
          assert_equal(1, result.size)
          assert_equal(1, result.first.number)
        end
      end
    end
  end
end
