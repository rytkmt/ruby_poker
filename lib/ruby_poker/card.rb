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

    def inspect
      suit_str =
        case @suit
        when :spade; "♠"
        when :heart; "♥"
        when :diamond; "♦"
        when :club; "♣"
        end

      number_str =
        case @number
        when 1; "A"
        when 13; "K"
        when 12; "Q"
        when 11; "J"
        else; @number
        end

      color =
        case @suit
        when :spade; :blue
        when :heart; :red
        when :diamond; :yellow
        when :club; :green
        end

      Rainbow("[#{suit_str} #{number_str}]").send(color)
    end
  end
end
