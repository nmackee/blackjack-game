class Card
  attr_accessor :face, :suit, :value

  def initialize(face, suit, value)
    @face = face
    @suit = suit
    @value = value
  end

  def show_card
    # return "#{@face}  #{@suit} : #{@value}"
    return "#{@suit} の #{face}"
  end
end
