require "test_helper"

module RubyPoker
  class Hand
    module HandTypeJudgers
      class FullHouseTest < Test::Unit::TestCase
        def setup
          @create_card = lambda do |suit: nil, number: nil|
            suit ||= RubyPoker::SUITS.sample
            number ||= RubyPoker::NUMBERS.sample
            Card.new(suit: suit, number: number)
          end

          @create_cards = ->(args) { args.map { |suit, number| @create_card.(suit: suit, number: number) } }
          @call_judge = ->(args) { RubyPoker::Hand::HandTypeJudgers::FullHouse.judge(cards: @create_cards.(args)) }
        end

        test "match" do
          result = @call_judge.([
            [:spade, 10],
            [:heart, 10],
            [:club, 10],
            [:diamond, 1],
            [:spade, 1],
          ])
          assert_equal(3, result.size)
          assert_equal([10], result.map(&:number).uniq)
        end

        test "not exist three of a kind" do
          assert_nil(@call_judge.([
            [:spade, 11],
            [:heart, 11],
            [:club, 10],
            [:diamond, 10],
            [:spade, 1],
          ]))
        end

        test "not exist two of a kind" do
          assert_nil(@call_judge.([
            [:spade, 11],
            [:heart, 11],
            [:club, 11],
            [:diamond, 10],
            [:spade, 1],
          ]))
        end
      end
    end
  end
end
