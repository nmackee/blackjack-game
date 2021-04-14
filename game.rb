require "./player.rb"
require "./deck.rb"
require "./card.rb"

class Game
  def self.run
    self.new.run
  end

  @@game_count = 0

  def run
    puts "Wellcome to BlackJack Game!!"
    puts "What your name?"
    @name = gets.chomp.to_s
    begin
      @@game_count += 1
      blank_line
      puts "【Round #{@@game_count}！】"

      puts "game start!"
      blank_line
      build_player

      @player.how_money_bet
      build_deck

      deal_to_player
      deal_to_dealer

      player_hit_or_stay if !player_finished?
      dealer_hit_or_stay if @player_blackjack_flag != true

      sleep(3)

      show_hole_card
      @player.culculate_total_disp
      @dealer.culculate_total_disp
      # blackjack_info
      player_refund
    end while game_again == 1
    puts "See You again!"
    # end
  end

  def deal_to_player
    @player.draw_card(2, @deck)
    @player.player_disp_hands

    @player_blackjack_flag = false

    if player_is_blackjack?
      puts @player.total
      # puts "Your hand of BlackJack!!"
      @player_blackjack_flag = true
      blackjack_info
      blank_line
    else
      @player.culculate_total_disp
    end
  end

  def deal_to_dealer
    @dealer.draw_card(2, @deck)
    dealer_disp_hands

    @dealer_blackjack_flag = false
    if dealer_is_blackjack?
      @dealer_blackjack_flag = true
    end

    blank_line
  end

  def show_hole_card
    puts "#{@dealer.name}'s hole card: #{@hole_card}"
  end

  def dealer_disp_hands
    blank_line
    puts "#{@dealer.name}'s hands"
    # @dealer.hands.each.with_index(1) do |hand, i|
    @dealer.hands.map.with_index(1) do |hand, i|
      if i != 2
        puts "#{i}枚目: #{hand.show_card}"
      else
        puts "2枚目: don't show"
        @hole_card = hand.show_card
      end
    end
  end

  def player_is_blackjack?
    @player.total == 21
  end

  def dealer_is_blackjack?
    @dealer.total == 21
  end

  def blackjack_info
    if @player_blackjack_flag == true
      print "#{@player.name}'s hand of BLACJACK!"
    elsif @dealer_blackjack_flag == true
      print "#{@dealer.name}'s hand of BLACJACK..."
    end
  end

  def build_player
    @player = Player.new(@name, 0, [])
    @dealer = Player.new("Computer", 0, [])
  end

  def build_deck
    @deck = Deck.new
  end

  def player_hit_or_stay
    loop do
      begin
        puts "hit or stay?"
        print "1.h/ 2.s > "
        answer = gets.to_i
      end

      if answer == 1
        puts "#{@player.name} hit!"
        player_hit
        if player_finished?
          break
        end
      elsif answer == 2
        puts "#{@player.name} stay!"
        blank_line
        break
      end
    end
  end

  def player_hit
    @player.draw_card(1, @deck)
    @player.player_disp_hands
    @player.culculate_total_disp
    blank_line
  end

  def dealer_hit_or_stay
    while true
      dealer_hit? ? dealer_hit : break
    end
  end

  def dealer_hit
    puts "Dealer hit!"
    @dealer.draw_card(1, @deck)
    # @dealer.dealer_disp_hands
    dealer_disp_hands

    blank_line
  end

  def dealer_hit?
    @dealer.total < 17
  end

  def win_or_lose
    blank_line
    if @player_blackjack_flag == true && @dealer_blackjack_flag == true
      puts "Both hands: BLACKJACK, draw"
      return :draw
    elsif @player_blackjack_flag == true
      blackjack_info
      puts " you win!"
      return :special_win
    elsif @dealer_blackjack_flag == true
      blackjack_info
      puts " you lose"
      return :lose
    elsif player_burst?
      puts "You bursted, You lose"
      return :lose
    elsif dealer_burst?
      puts "Dealer bursted, You win"
      return :win
    else
      case @player.total <=> @dealer.total
      when 1
        puts "You win!"
        return :win
      when -1
        puts "You lose"
        return :lose
      else
        puts "draw"
        return :draw
      end
    end
  end

  def player_burst?
    @player.total > 21
  end

  def dealer_burst?
    @dealer.total > 21
  end

  def player_finished?
    @player.total >= 21
  end

  def player_refund
    @result = win_or_lose
    case @result
    when :special_win then @player.specail_win_refund(@player.bet)
    when :win then @player.win_refund(@player.bet)
    when :lose then @player.lose_refund(@player.bet)
    when :draw then @player.draw_refund
    end
  end

  def blank_line
    puts
  end

  def game_again
    blank_line
    if !@player.game_over
      begin
        puts "play again or end?"
        print "1.play / 2.end > "

        input = gets.chomp.to_i
      end while input != 1 && input != 2
    elsif puts "You have no money, Game Over"
    end
    return input
  end
end

Game.run
