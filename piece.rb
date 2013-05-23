class Piece
  attr_accessor :color ,:display, :king, :possible_vectors
  
  def initialize(color)
    @color = color
    @display = (color == :white ? "\u263A" : "\u263B")
    @king = false
    @possible_vectors = (@color == :white ? [[1,1], [1,-1]] : [[-1,1],[-1,-1]])
    @king_vectors = [[1,1], [1,-1], [-1,1],[-1,-1]]
  end
  
  def slide_moves(current_pos, board)
    slide_moves = []
    self.possible_vectors.each do |vector|
      new_position = adjusted_position(current_pos, vector)
      slide_moves << new_position if board.space_contents(new_position) == :_
    end
    slide_moves
  end
  
  def jump_moves(current_pos, board, color)
    color = (color == :white ? :black : :white)
    jump_moves = {}
    
    self.possible_vectors.each do |vector|
      new_position = adjusted_position(current_pos, vector)
      if board.color(new_position) == color
        jump_position = adjusted_position(new_position, vector)
        jump_moves[jump_position] = new_position if board.space_contents(jump_position) == :_
      end
    end
    jump_moves
  end
  
  def perform_slide(current_pos, end_pos, board)
    slide_moves = slide_moves(current_pos, board)
    board.move_piece(current_pos, end_pos, self) if slide_moves.include?(end_pos)
  end
  
  def perform_jump(current_pos, end_pos, board)
    color = self.color
    jump_moves = jump_moves(current_pos, board, color)
    if jump_moves.keys.include?(end_pos)
      board.jump_piece(current_pos, end_pos, jump_moves[end_pos], self)
    end
  end
      
  def adjusted_position(start_loc, move_dir)
    [start_loc.first + move_dir.first, start_loc.last + move_dir.last]
  end
end
