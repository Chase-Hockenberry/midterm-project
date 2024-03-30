class Card
    attr_reader :suit, :value
  
    def initialize(suit, value)
      @suit = suit
      @value = value
    end
  
    def to_s
      "#{value} of #{suit}"
    end
  end
  
    class Deck
        SUITS = ['Hearts', 'Diamonds', 'Clubs', 'Spades'].freeze
        VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'].freeze
  
        attr_accessor :cards
  
        def initialize
          @cards = []
              SUITS.each do |suit|
                VALUES.each do |value|
                    @cards << Card.new(suit, value)
                end
              end
          shuffle!
        end
  
        def shuffle!
          @cards.shuffle!
        end

        def deal(num)
          @cards.pop(num)
        end
      end
    end
    class Hand
        attr_accessor :cards
  
        def initialize(cards)
          @cards = cards
        end
  
        def to_s
          @cards.map(&:to_s).join(', ')
        end
  
        def discard(indices, deck)
          indices.each do |index|
            @cards[index] = deck.deal(1).first
          end
        end
  
        def evaluate_strength
          case
          when straight_flush? then [8, straight_flush_value]
          when four_of_a_kind? then [7, four_of_a_kind_value]
          when full_house? then [6, full_house_value]
          when flush? then [5, flush_value]
          when straight? then [4, straight_value]
          when three_of_a_kind? then [3, three_of_a_kind_value]
          when two_pair? then [2, two_pair_value]
          when one_pair? then [1, one_pair_value]
          else [0, high_card_value]
          end
        end
        end
        private
  
        def sorted_values
          @cards.map { |card| Deck::VALUES.index(card.value) }.sort.reverse
        end
        def straight_flush?
          straight? && flush?
        end
        def straight_flush_value
          straight_value
        end
        def four_of_a_kind?
          values_count.values.include?(4)
        end
        def four_of_a_kind_value
          values_count.key(4)
        end
        def full_house?
          values_count.values.include?(3) && values_count.values.include?(2)
        end
        def full_house_value
          values_count.select { |_, count| count == 3 }.keys.first
        end
        def flush?
          suits_count.values.include?(5)
        end
        def flush_value
          sorted_values
        end
        def straight?
          (0..3).each { |i| return false unless sorted_values[i] - 1 == sorted_values[i + 1] }
          true
        end
        def straight_value
          sorted_values.first
        end
        def three_of_a_kind?
          values_count.values.include?(3)
        end
        def three_of_a_kind_value
          values_count.key(3)
        end
        def two_pair?
          values_count.values.count(2) == 2
        end  
        def two_pair_value
          values_count.select { |_, count| count == 2 }.keys.sort.reverse
        end
        def one_pair?
          values_count.values.include?(2)
        end
        def one_pair_value
          values_count.key(2)
        end
        def high_card_value
          sorted_values
        end
        def values_count
          @cards.group_by(&:value).transform_values(&:size)
        end
        def suits_count
          @cards.group_by(&:suit).transform_values(&:size)
        end
      end
    class Player
        attr_accessor :hand, :pot, :folded
  
        def initialize(hand)
          @hand = hand
          @pot = 1000
          @folded = false
        end
  
        def discard_cards(deck)
          puts "Hand: #{hand}"
          puts "Enter indices of cards to discard (0 2 4); press enter to skip:"
          input = gets.chomp
          return if input.empty?
  
          indices = input.split.map(&:to_i)
          hand.discard(indices, deck)
          puts "New hand: #{hand}"
        end
  
        def action(current_bet)
          return :fold if folded
  
          puts "Pot: #{@pot}. Current bet: #{current_bet}"
          puts "Fold(f), See(s), or Raise(r)?"
          action = gets.chomp.downcase
          case action
          when 'f' then :fold
          when 's' then :see
          when 'r' then :raise
          else action
          end
        end
      end    
  
    end
    class Game
        attr_reader :deck, :players, :pot, :current_bet
  
        def initialize(num_players)
          @deck = Deck.new
          @players = []
          num_players.times { @players << Player.new(Hand.new(deck.deal(5))) }
          @pot = 0
          @current_bet = 0
        end
  
        def play_round
          @pot = 0
          @current_bet = 0
  
          players.each do |player|
            player.discard_cards(deck)
          end
  
          players.each do |player|
            action = player.action
            case action
            when :fold
              players.delete(player)
              puts "Player folds."
            when :see
              player.pot -= current_bet
              @pot += current_bet
              puts "Player sees."
            when :raise
              puts "Enter raise amount:"
              raise_amount = gets.chomp.to_i
              raise "Invalid raise amount" if raise_amount <= current_bet
              player.pot -= raise_amount
              @pot += raise_amount
              @current_bet = raise_amount
              puts "Player raises."
            end
          end
  
          winner = determine_winner
          distribute_pot(winner)
        end
  
        private
  
        def determine_winner
            best_strength = nil
            winning_players = []
        
            players.each do |player|
              strength = player.hand.evaluate_strength
              if best_strength.nil? || strength > best_strength
                best_strength = strength
                winning_players = [player]
              elsif strength == best_strength
                winning_players << player
              end
            end
    
            winning_players
          end
  
        def distribute_pot(winning_players)
          pot_per_player = pot / winning_players.size
          winning_players.each do |player|
            player.pot += pot_per_player
          end
          puts "Pot distributed."
        end
end
  
  game = Game.new(4)
  game.play_round
