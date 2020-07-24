require "test_helper"

module RubyPoker
  class DeckTest < Test::Unit::TestCase
    def setup
      @create_card = lambda do |suit: nil, number: nil|
        suit ||= RubyPoker::SUITS.sample
        number ||= RubyPoker::NUMBERS.sample
        Card.new(suit: suit, number: number)
      end
      @create_cards = ->(n) { n.times.map { @create_card.call } }
    end
    test "#initialize" do
      deck = Deck.new
      cards = deck.instance_variable_get(:@cards)
      assert_equal(52, cards.size)
      assert_equal(([RubyPoker::NUMBERS] * 4).transpose.flatten, cards.sort.reverse.map(&:number))
      assert_equal(([RubyPoker::SUITS] * 13).flatten, cards.sort.reverse.map(&:suit))
    end

    test "#trush" do
      deck = Deck.new
      cards = @create_cards.(3)
      deck.trush(cards: cards)
      assert_equal(cards, deck.instance_variable_get(:@trushed))
    end

    sub_test_case "#draw" do
      test "shorted cards" do
        deck = Deck.new
        assert_raise_kind_of(ArgumentError) do
          deck.draw(count: 53)
        end
      end

      test "merge_trushed" do
        deck = Deck.new
        cards = [
          @create_card.(suit: :heart, number: 1),
          @create_card.(suit: :heart, number: 2),
          @create_card.(suit: :heart, number: 3),
        ]
        deck.instance_variable_set(:@cards, cards.dup)

        trushed = [
          @create_card.(suit: :heart, number: 4),
          @create_card.(suit: :heart, number: 5),
        ]
        deck.instance_variable_set(:@trushed, trushed.dup)
        drawed_cards = deck.draw(count: 5)
        assert_not_equal(cards, drawed_cards.take(3))
        assert_equal((cards + trushed).sort, drawed_cards.sort)
      end

      test "simple draw" do
        deck = Deck.new
        cards = [
          @create_card.(suit: :heart, number: 1),
          @create_card.(suit: :heart, number: 2),
          @create_card.(suit: :heart, number: 3),
          @create_card.(suit: :heart, number: 4),
        ]
        deck.instance_variable_set(:@cards, cards.dup)
        drawed_cards = deck.draw(count: 2)
        deck_cards = deck.instance_variable_get(:@cards)
        assert_equal(cards.take(2), drawed_cards)
        assert_equal(cards[2..3], deck_cards)
      end
    end
  end
end
