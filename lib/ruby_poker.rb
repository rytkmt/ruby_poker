require "ruby_poker/version"
require "ruby_poker/card"

module RubyPoker
  NUMBERS = ([*2..13] + [1]).freeze
  # indexで比較するため弱い順で定義を行うが、見た目上強い順に定義してreverseする
  SUITS = %i[spade heart diamond club].reverse.freeze
end
