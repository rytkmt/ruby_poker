require "test_helper"

module RubyPoker
  class Hand
    module HandTypeJudgers
      class FlushTest < Test::Unit::TestCase
        def setup
          @create_card = lambda do |suit: nil, number: nil|
            suit ||= RubyPoker::SUITS.sample
            number ||= RubyPoker::NUMBERS.sample
            Card.new(suit: suit, number: number)
          end

          @create_cards = ->(args) { args.map { |suit, number| @create_card.(suit: suit, number: number) } }
          @call_judge = ->(args) { RubyPoker::Hand::HandTypeJudgers::Flush.judge(cards: @create_cards.(args)) }
        end

        test "match spade" do
          assert_not_nil(@call_judge.([
            [:spade, 9],
            [:spade, 11],
            [:spade, 7],
            [:spade, 1],
            [:spade, 13],
          ]))
        end

        test "match diamond" do
          assert_not_nil(@call_judge.([
            [:diamond, 2],
            [:diamond, 8],
            [:diamond, 4],
            [:diamond, 5],
            [:diamond, 6],
          ]))
        end

        test "disparate suit" do
          assert_nil(@call_judge.([
            [:diamond, 2],
            [:club, 3],
            [:diamond, 8],
            [:diamond, 5],
            [:diamond, 6],
          ]))
        end
      end
    end
  end
end
