require "ruby_poker/version"
require "ruby_poker/card"

module RubyPoker
  NUMBERS = ([*2..13] + [1]).freeze
  SUITS = %i[club diamond heart spade].freeze
end
