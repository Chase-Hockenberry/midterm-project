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
    class Player

    end
    class Game
        
    end
end
