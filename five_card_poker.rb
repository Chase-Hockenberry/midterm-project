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

    end
    class Player

    end
    class Game
        
    end
end
