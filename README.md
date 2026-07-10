# Ruby Poker

RubyによるドローポーカーのCLI実装です。オブジェクト指向設計の実践として、ポーカーのドメインをRubyらしく表現することを目指しました。

## 背景

Qiitaで駆け出しエンジニアが[Rubyでポーカー実装にチャレンジしている記事](https://qiita.com/paraizo2424/items/23f5ab031dbda184ce9d)を見かけ  
「カードの情報をHashではなくクラスに切り出す」「役判定をPlayerから分離する」といった設計面のアドバイスを[コメント](https://qiita.com/paraizo2424/items/23f5ab031dbda184ce9d#comment-869ec4939a927b872635)しました。

アドバイスしているうちに「自分ならどこまできれいに設計・実装できるか」を試してみたくなり、エンジニア経験が長くなった今の自分の力で一から取り組んでみることにしました。

ドメインの「モノ」と「概念」を明確に分離し、各オブジェクトが自身の責務のみを持つ設計を意識しています。

設計の検討過程と実装の詳細は [Qiitaに連載記事として公開](https://qiita.com/r12tkmt/items/56a60f2d69226b2bdcf2) していますので、あわせてご覧ください。

## 概要

ターミナル上で複数人対戦の5カードドローポーカーをプレイできます。

- ジョーカーなし（将来追加を考慮した構造）
- ベット（掛け金）なし、1回の勝負で勝敗を決定
- 全プレイヤーを実行者が操作する形式

## 設計のポイント

### Comparable による自然な比較演算

Card・Hand・Player の各クラスに `Comparable` を mixin し、`<=>` 演算子を実装しています。これにより、カードの強弱・役の優劣・プレイヤーの勝敗がすべて標準メソッドで扱えます。

```ruby
Card.new(suit: :spade, number: 1) > Card.new(suit: :heart, number: 13) #=> true (Aceが最強)
winner = @players.max
```

### Strategy パターンによる役判定

10種のポーカー役をそれぞれ独立したモジュール（`HandTypeJudgers::*`）として実装し、役の強い順に判定を試行する構造です。

```ruby
HAND_TYPES = %i[royal_straight_flush straight_flush four_of_a_kind ...]

matched_type = HAND_TYPES.find do |type|
  judger = HandTypeJudgers.const_get(type.to_s.classify)
  matched_cards = judger.judge(cards: cards)
end
```

ActiveSupportの `classify` と `const_get` による動的ディスパッチで、新しい役の追加時にも判定ロジック全体を変更する必要がありません。ローカルルールによる役の追加も容易に行える拡張性を持たせています。

### 責務の明確な分離

ドメインを「モノ（カード、プレイヤー）」と「概念（山札、役）」に分け、各クラスが単一の責務を持つよう設計しています。

| クラス | 責務 |
|--------|------|
| `Card` | スートと数字の保持、カード間の強弱比較 |
| `Hand` | 5枚のカードから役を判定、役同士の比較 |
| `Player` | 手札の管理とカード交換、プレイヤー間の勝敗比較 |
| `Deck` | 52枚の管理、シャッフル、捨て札のリサイクル |
| `Game` | ゲーム進行の制御（ターン管理・入出力） |

### Ace（エース）の扱い

数字としては1ですが、ポーカーでは最強のカードです。数字の強さ順を `[1, 13, 12, ..., 2]` で定義し、`index` によるレベル比較でAceが自然に最強となる仕組みを実現しています。ストレートにおいても「A-2-3-4-5」は最弱、「10-J-Q-K-A」はロイヤルストレートフラッシュとして正しく判定されます。

### その他の工夫

- **捨て札のリサイクル**: 山札不足時に捨て札をシャッフルして再利用する実カジノ的な挙動
- **カード交換時の削除順序**: インデックスの大きい方から削除することで配列のズレを防止
- **カラー表示**: Rainbow gem でスートごとに色分けした視認性の高いカード表示

## クラス構成

```
lib/ruby_poker/
├── card.rb                        # カード
├── hand.rb                        # 役（判定 + 比較）
│   └── hand/hand_type_judgers/    # 各役の判定ロジック
│       ├── royal_straight_flush.rb
│       ├── straight_flush.rb
│       ├── four_of_a_kind.rb
│       ├── full_house.rb
│       ├── flush.rb
│       ├── straight.rb
│       ├── three_of_a_kind.rb
│       ├── two_pair.rb
│       ├── one_pair.rb
│       └── high_card.rb
├── player.rb                      # プレイヤー
├── deck.rb                        # 山札
└── game.rb                        # ゲーム進行
```

## 使い方

```ruby
require "ruby_poker"
RubyPoker.play
```

## テスト

test-unit によるユニットテストを各クラス・各役判定ロジックに対して記述しています。

```bash
bundle exec rake test
```

## 関連記事

設計の検討過程と実装の詳細を Qiita に連載しています。

1. [準備編](https://qiita.com/r12tkmt/items/56a60f2d69226b2bdcf2) — スコープ定義と登場人物の整理
2. [test-unit準備編](https://qiita.com/r12tkmt/items/48940d0e09a77d210bf2) — テスト環境の構築
3. [実装編1（カード）](https://qiita.com/r12tkmt/items/175aa66fd91995f13524) — Comparable による比較設計
4. [実装編2（役）](https://qiita.com/r12tkmt/items/cd22e04eb102eabf03cd) — Strategy パターンでの役判定
5. [実装編3（プレイヤー）](https://qiita.com/r12tkmt/items/ae44086d9bf7d01e7572) — カード交換と委譲の検討
6. [実装編4（山札）](https://qiita.com/r12tkmt/items/649dbd9a6e4d097ceb4c) — 山札管理と破壊的変更の注意点
7. [実装編5（ゲーム）【完結】](https://qiita.com/r12tkmt/items/88d8a3c213efebad7f4a) — ゲーム進行の組み上げ
