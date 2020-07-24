require "test_helper"

module RubyPoker
  class PlayerTest < Test::Unit::TestCase
    def setup
      @create_card = lambda do |suit: nil, number: nil|
        suit ||= RubyPoker::SUITS.sample
        number ||= RubyPoker::NUMBERS.sample
        Card.new(suit: suit, number: number)
      end
      @create_cards = ->(n) { n.times.map { @create_card.call } }
      @player = Player.new(cards: @create_cards.(5))
    end
    sub_test_case "#change" do
      test "correct arguments" do
        cards = []
        cards << @create_card.(number: 1)
        cards << @create_card.(number: 2)
        cards << @create_card.(number: 3)
        cards << @create_card.(number: 4)
        cards << @create_card.(number: 5)
        player = Player.new(cards: cards)

        new_cards = []
        new_cards << @create_card.(number: 6)
        new_cards << @create_card.(number: 7)

        trushed = player.change(indexes: [0, 2], new_cards: new_cards)
        numbers = player.instance_variable_get(:@cards).map(&:number)
        assert_equal([2,4,5,6,7], numbers)
        hand = player.instance_variable_get(:@hand)
        assert_equal(:high_card, hand.hand_type)
        assert_equal(7, hand.comparison_card.number)
        assert_equal([1,3], trushed.map(&:number).sort)
      end

      test "wrong change cards size" do
        assert_raise_kind_of(ArgumentError) do
          @player.change(indexes: [0], new_cards: @create_cards.(2))
        end
      end

      test "wrong index number" do
        assert_raise_kind_of(ArgumentError) do
          @player.change(indexes: [0, 6], new_cards: @create_cards.(2))
        end
      end
    end
  end
end
