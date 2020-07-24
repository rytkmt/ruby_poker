module RubyPoker
  class Game
    def self.play
      new.send(:play)
    end

    def initialize
      @deck = Deck.new
    end

  private

    def play
      puts "＜ゲーム開始＞"

      init_players(count: input_player_count)
      @players.each { |player| turn(player: player) }

      judge

      puts "＜ゲーム終了＞"
    end

    def init_players(count:)
      @players = count.times.map { |i| Player.new(name: "プレイヤー#{i + 1}", cards: @deck.draw(count: 5)) }
    end

    def turn(player:)
      puts "\n#{player.name} のターンです"
      player.show

      puts "カードの交換ができます"
      indexes = input_change_indexes
      return if indexes.empty?

      new_cards = @deck.draw(count: indexes.size)
      trushed = player.change(indexes: indexes, new_cards: new_cards)
      @deck.trush(cards: trushed)
      player.show
    end

    def input_player_count
      puts "プレイヤーの参加人数を入力してください(1～7)"
      player_count = gets.to_i
      return player_count if (1..7).include?(player_count)
      puts "入力が間違っています"
      input_player_count
    end

    def input_change_indexes
      puts "捨てるカードの番号を半角スペース区切りで入力してください（なければそのままEnter）"

      indexes = gets.chomp.split.map(&:to_i)
      return indexes.map { |i| i - 1 }.sort if indexes.all? { |i| (1..5).include?(i) }
      input_change_indexes
    end

    def judge
      puts "----- 結果 -----"
      @players.each do |player|
        puts "#{player.name} の手札"
        player.show
        puts ""
      end

      winner = @players.max
      puts Rainbow("\n#{winner.name} の勝ち 👏👏").underline
    end
  end
end
