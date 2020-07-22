require "test_helper"

module RubyPoker
  class CardTest < Test::Unit::TestCase
    sub_test_case "#initialize" do
      test "correct arguments" do
        assert_nothing_raised do
          Card.new(suit: :heart, number: 3)
        end
      end

      test "wrong suit" do
        assert_raise_kind_of(ArgumentError) do
          Card.new(suit: :test, number: 3)
        end
      end

      test "wrong number" do
        assert_raise_kind_of(ArgumentError) do
          Card.new(suite: :heart, number: 14)
        end
      end
    end

    sub_test_case "#<=>" do
      sub_test_case "compare number" do
        test "simple numbers" do
          a = RubyPoker::Card.new(suit: :heart, number: 8)
          b = RubyPoker::Card.new(suit: :heart, number: 2)
          assert(a > b)
        end

        test "compare ace" do
          a = RubyPoker::Card.new(suit: :heart, number: 13)
          b = RubyPoker::Card.new(suit: :heart, number: 1)
          assert(a < b)
        end

        test "max number" do
          cards = [*1..5]
            .shuffle
            .map { |i| RubyPoker::Card.new(suit: :heart, number: i) }

          assert_equal(1, cards.max.number)
        end
      end

      sub_test_case "compare suit(same number)" do
        test "spade and heart" do
          a = RubyPoker::Card.new(suit: :spade, number: 1)
          b = RubyPoker::Card.new(suit: :heart, number: 1)
          assert(a > b)
        end

        test "heart and club" do
          a = RubyPoker::Card.new(suit: :club, number: 1)
          b = RubyPoker::Card.new(suit: :heart, number: 1)
          assert(a < b)
        end

        test "spade and diamond" do
          a = RubyPoker::Card.new(suit: :spade, number: 1)
          b = RubyPoker::Card.new(suit: :diamond, number: 1)
          assert(a > b)
        end
      end
    end
  end
end
