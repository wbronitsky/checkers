require './board.rb'
require './humanplayer.rb'
require './piece.rb'

class Game
  attr_accessor :board, :player1, :player2
  
  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new(:white)
    @player2 = HumanPlayer.new(:black)
    @current_player = @player1
    @other_player = @player2
  end
  
  def play
    while true
      input_loop
      @current_player, @other_player = @other_player, @current_player
      @board.king_check
      break if win?(@other_player.color)
    end
    puts "#{@current_player.color} wins!"
  end
  
  def input_loop
    move_array = @current_player.move(@board)
    start_position = move_array[0][1]
    begin
      if @board.color(start_position) == @other_player.color
        raise InvalidMoveError 
      end
      @board.space_contents(start_position).perform_moves(move_array, @board)
    rescue InvalidMoveError => e
      puts "Not a valid move"
      input_loop
    rescue NoMethodError => n
      puts "Please select an actual piece"
      input_loop
    end
  end
  
  def win?(color)
    @board.board.each_with_index do |line, y|
      line.each_with_index do |space, x|
        return false if board.color([y,x]) == color
      end
    end
    true
  end     
end

game = Game.new
game.play