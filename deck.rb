class Deck
  # attr_accessor :cards

  def initialize
    @faces = [*(2..10), "Jack", "Queen", "King", "Ace"]
    @suits = ["clubs", "spades", "hearts", "diamonds"]
    @cards = []

    @faces.each do |face|
      if face.class == Integer
        value = face
      elsif face == "Ace"
        value = 1
      else
        value = 10
      end
      @suits.each do |suit|
        card = Card.new(face, suit, value)
        @cards << card
      end
      # @cards.each do |card, (face, suit, value)|
      #   puts "#{card.face}  #{card.suit} #{card.value}"
      # end
    end
    @cards.shuffle!
    return @cards
    # puts "#{@cards[0].face}"
  end

  def generate_card
    @cards.shift
  end
end
