require './piece.rb'
class HumanPlayer
  attr_accessor :color
  
  def initialize(color)
    @color = color
  end
  
  def move(board)
    board.render
    puts "It is #{self.color}'s turn"
    puts "How would you like to move?"
    puts "Formatted as: jump/slide starty,startx endy,endx: jump start end..."
    input = gets.chomp.split(":")
    parsed_input(input)
  end
  
  private 
  
  def parsed_input(input)
    output = []
    input.each do |move|
      move_array = move.split(" ")
      type_of_move = move_array.first
      start_position = move_array[1].split(",").map(&:to_i)
      end_position = move_array.last.split(",").map(&:to_i)
      output << [type_of_move, start_position, end_position
    end
    output
  end
end

