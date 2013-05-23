require './piece.rb'
require 'colorize'

class Board
  attr_accessor :board
  
  def initialize
    @board = generate_board
    add_pieces
  end

  def generate_board
    board = blank_board
  end

  def blank_board
    (0...8).map { [:_] * 8 }
  end

  def render
    print "  0 1 2 3 4 5 6 7\n"
    @board.each_with_index do |line, index|
      print index
      line.each do |position|
        print " "
        print (position == :_ ? :_ : position.display)
      end
      print "\n"
    end
    print "\n"
  end
  
  def add_pieces
    white = [[0,1], [0,3], [0,5], [0,7], 
             [1,0], [1,2], [1,4], [1,6], 
             [2,1], [2,3], [2,5], [2,7]]
    black = [[5,0], [5,2], [5,4], [5,6], 
             [6,1], [6,3], [6,5], [6,7],
             [7,0], [7,2], [7,4], [7,6]]
    colors = [white, black]
    colors.each_with_index do |color, index|
      color_sym = (index == 0 ? :white : :black)
      color.each do |position|
        @board[position.first][position.last] = Piece.new(color_sym)
      end
    end
  end
  
  def move_piece(current_pos, end_pos, piece)
    place_piece(current_pos)
    place_piece(end_pos, piece)
  end
  
  def jump_piece(current_pos, end_pos, jump_pos, piece)
    move_piece(current_pos, end_pos, piece)
    place_piece(jump_pos)
  end
  
  def place_piece(position, piece = :_)
    @board[position.first][position.last] = piece
  end
  
  def space_contents(position)
    @board[position.first][position.last]
  end
  
  def color(position)
    return nil if space_contents(position) == :_
    space_contents(position).color
  end
  
  def king_check
    @board.each_with_index do |line, y|
      line.each do |space|
        if space.color == :white && y == 7
          space.king = true
          space.display = "\u2654"
        end
        if space.color == :black and y == 0
          space.king = true
          space.display = "\u265A"
        end
      end
    end
  end   
end