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

      indexes.sort.reverse_each { |i| @cards.delete_at(i) }
      @cards += new_cards
      @hand = Hand.new(cards: @cards)
    end
  end
end
