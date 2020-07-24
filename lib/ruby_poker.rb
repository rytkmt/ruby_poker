require "ruby_poker/version"
require "active_support/all"
require "rainbow"
Dir[__dir__ + "/ruby_poker/*.rb"].each { |p| require p }

module RubyPoker
  NUMBERS = ([1] + [*2..13].reverse).freeze
  SUITS = %i[spade heart diamond club].freeze
  HAND_TYPES = %i[
    royal_straight_flush
    straight_flush
    four_of_a_kind
    full_house
    flush
    straight
    three_of_a_kind
    two_pair
    one_pair
    high_card
  ].freeze

  def self.play
    RubyPoker::Game.play
  end
end
