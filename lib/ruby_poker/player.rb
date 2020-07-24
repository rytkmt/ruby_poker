module RubyPoker
  class Player
    include Comparable
    delegate :<=>, to: :@hand

    def initialize(cards:)
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
  end
end
