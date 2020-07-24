module RubyPoker
  class Player
    include Comparable
    attr_reader :name, :hand

    def initialize(name:, cards:)
      @name = name
      @cards = cards
      @hand = Hand.new(cards: cards)
    end

    def change(indexes:, new_cards:)
      raise(ArgumentError) unless indexes.size == new_cards.size
      raise(ArgumentError) unless indexes.all? { |i| (0..4).include?(i) }

      trushed = indexes.sort.reverse.each_with_object([]) { |i, trushed| trushed << @cards.delete_at(i) }
      @cards += new_cards
      @hand = Hand.new(cards: @cards)
      trushed
    end

    def <=>(other)
      @hand <=> other.hand
    end

    def inspect
      cards_str = @cards.map.with_index(1) do |card, i|
        "#{i}. #{card.inspect}"
      end.join("   ")

      cards_str + "\n" + @hand.inspect + "\n"
    end
  end
end
