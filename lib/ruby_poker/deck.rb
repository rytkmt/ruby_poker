module RubyPoker
  class Deck
    def initialize
      @cards = init_cards
      @trushed = []
    end

    def draw(count:)
      merge_trushed if @cards.size < count
      raise(ArgumentError, "No cards.") if @cards.size < count
      @cards.shift(count)
    end

    def trush(cards:)
      @trushed += cards
    end

  private

    def init_cards
      RubyPoker::SUITS.each_with_object([]) do |suit, cards|
        cards.concat(
          RubyPoker::NUMBERS.map { |number| Card.new(suit: suit, number: number) }
        )
      end.shuffle
    end

    def merge_trushed
      @cards += @trushed
      @cards.shuffle!
      @trushed = []
    end
  end
end
