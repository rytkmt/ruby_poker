module RubyPoker
  class Card
    include Comparable
    attr_reader :suit, :number

    def initialize(suit:, number:)
      raise(ArgumentError) unless RubyPoker::SUITS.include?(suit)
      raise(ArgumentError) unless RubyPoker::NUMBERS.include?(number)

      @suit = suit
      @number = number
    end

    def suit_level
      RubyPoker::SUITS.reverse.index(@suit)
    end

    def number_level
      RubyPoker::NUMBERS.reverse.index(@number)
    end

    def <=>(other)
      number_comparision = number_level <=> other.number_level
      number_comparision.zero? ? suit_level <=> other.suit_level : number_comparision
    end
  end
end
