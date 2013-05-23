class InvalidMoveError < StandardError
end

class Piece
  attr_accessor :color ,:display, :king, :possible_vectors, :king_vectors
  
  def initialize(color)
    @color = color
    @display = (color == :white ? "\u263A" : "\u263B")
    @king = false
    @possible_vectors = (@color == :white ? [[1,1], [1,-1]] : [[-1,1],[-1,-1]])
    @king_vectors = [[1,1], [1,-1], [-1,1],[-1,-1]]
  end
  
  def slide_moves(current_pos, board)
    slide_moves = []
    use_vectors = (self.king ? self.king_vectors : self.possible_vectors)
    use_vectors.each do |vector|
      new_position = adjusted_position(current_pos, vector) 
      next unless on_board?(new_position)
      slide_moves << new_position if board.space_contents(new_position) == :_
    end
    slide_moves
  end
  
  def jump_moves(current_pos, board, color)
    color = (color == :white ? :black : :white)
    use_vectors = (self.king ? self.king_vectors : self.possible_vectors)
    jump_moves = {}
    use_vectors.each do |vector|
      new_position = adjusted_position(current_pos, vector)
      next unless on_board?(new_position)
      if board.color(new_position) == color
        jump_position = adjusted_position(new_position, vector)
        next unless on_board?(jump_position)
        jump_moves[jump_position] = new_position if board.space_contents(jump_position) == :_
      end
    end
    jump_moves
  end
  
  def perform_slide(current_pos, end_pos, board)
    color = board.space_contents(current_pos).color
    raise InvalidMoveError.new unless jump_moves(current_pos, board, color).empty?
    slide_moves = slide_moves(current_pos, board)
    if slide_moves.include?(end_pos)
      board.move_piece(current_pos, end_pos, self) 
      return true
    end
    false
  end
  
  def perform_jump(current_pos, end_pos, board)
    color = self.color
    jump_moves = jump_moves(current_pos, board, color)
    if jump_moves.keys.include?(end_pos)
      board.jump_piece(current_pos, end_pos, jump_moves[end_pos], self)
      return true
    end
    false
  end
      
  def adjusted_position(start_loc, move_dir)
    [start_loc.first + move_dir.first, start_loc.last + move_dir.last]
  end
  
  def on_board?(pos)
    pos.first.between?(0,7) && pos.last.between?(0,7)
  end
  
  def perform_moves!(move_sequence, board)
    #each move will be: [slide, start, end], [jump, start, end]
    move_sequence.each_with_index do |move , index|
      type = move.shift
      start_pos, end_pos = move
      if type == "slide"
        raise InvalidMoveError.new if index > 0
        value = perform_slide(start_pos, end_pos, board)
        raise InvalidMoveError.new unless value == true
      else
        value = perform_jump(start_pos, end_pos, board)
        raise InvalidMoveError.new unless value == true
      end
    end
  end
  
  def valid_move_seq?(move_sequence, board)
    new_board = Marshal.load(Marshal.dump(board))
    move_sequence = Marshal.load(Marshal.dump(move_sequence))
    begin
      perform_moves!(move_sequence, new_board)
    rescue InvalidMoveError => e
      return false
    end
    true
  end
  
  def perform_moves(move_sequence, board)
    if valid_move_seq?(move_sequence, board)
      perform_moves!(move_sequence, board) 
    else
      raise InvalidMoveError
    end
  end
end
