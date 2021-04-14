require "byebug"

class Player
  attr_reader :name, :total, :hands, :new_card, :bet, :target, :hole_card_flag
  @@bankroll = 100

  def initialize(name, total, hands)
    @name = name
    # @bankroll = bankroll
    @total = total = 0
    @hands = []
    @hole_card_flag = false
  end

  def draw_card(num, deck)
    num.times do
      @new_card = deck.generate_card
      @hands << @new_card
      culculate_total
    end
  end

  def player_disp_hands
    puts
    puts "#{@name}'s hands"
    @hands.each.with_index(1) do |hand, i|
      puts "#{i}枚目: #{hand.show_card}"
    end
  end

  def culculate_total
    @total += @new_card.value

    if @new_card.face == "Ace" && @total <= 11
      @total += 10
    end
    return @total
  end

  def how_money_bet
    begin
      puts "How many bet?"
      @bet = gets.chomp.to_i
    end until (1..@@bankroll).include?(@bet)
  end

  def win_refund(bet)
    @@bankroll += @bet
    # puts "#{@name}'s rollbank is #{@@bankroll}."
    show_rollbank
  end

  def lose_refund(bet)
    @@bankroll -= @bet
    # puts "#{@name}'s rollbank is #{@@bankroll}."
    show_rollbank
  end

  def draw_refund
    # puts "#{@name}'s rollbank is #{@bankroll}."
    show_rollbank
  end

  def specail_win_refund(bet)
    @@bankroll += @bet * 2
    # puts "#{@name}'s rollbank is #{@bankroll}."
    show_rollbank
  end

  def show_rollbank
    puts "#{@name}'s bankroll: #{@@bankroll}."
  end

  def culculate_total_disp
    puts "#{@name}'s total score: #{@total}"
  end

  def game_over
    @@bankroll <= 0
  end
end
