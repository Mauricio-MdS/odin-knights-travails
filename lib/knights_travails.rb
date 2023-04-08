# frozen_string_literal: true

# Knight represents the position of the Knight in a chess board.
# Must receive an initial position in the [n, n] format.
# Points to the shortest next position to the initial position in the board
class Knight
  MOVES = [[-2, -1], [-2, 1], [-1, -2], [-1, 2],
           [1, -2], [1, 2], [2, -1], [2, 1]].freeze

  attr_reader :position, :parent

  def initialize(position, parent)
    @position = position
    @parent = parent
  end

  # Receive avaiable board and checks which positions the knight can travel to.
  # Create new Knight positions.
  # Return all possible moves as an array.
  def check_moves(board)
    unchecked_moves = MOVES.map { |move| [move[0] + @position[0], move[1] + @position[1]] }
    moves = board.intersection(unchecked_moves)
    moves.map { |position| Knight.new(position, self) }
  end
end

# Board is a tree representing the shortest path from a initial position, to any other position in the chess board.
# Must receive a initial position in the [n, n] format, where n in 0..7
class Board
  def initialize(initial)
    @untraveled = Array(0..7).product(Array(0..7))
    @initial = Knight.new(initial, nil)
    @untraveled.delete(initial) { raise 'Invalid argument' }
  end

  # Returns an array of knight moves, where the first element is the initial position and the last is destination.
  def path_to(destination)
    current = build_path_to destination
    path = [current.position]
    until current == @initial
      current = current.parent
      path.push(current.position)
    end
    path.reverse
  end

  private

  def build_path_to(destination)
    queue = [@initial]
    loop do
      current = queue.shift
      return current if current.position == destination

      moves = current.check_moves(@untraveled)
      moves.each do |move|
        queue.push(move)
        @untraveled.delete(move)
      end
    end
  end
end

def knight_moves(initial, destination)
  board = Board.new(initial)
  path = board.path_to(destination)
  puts "You made it in #{path.length - 1} moves!  Here's your path:"
  path.each { |position| p position }
end

knight_moves([3, 3], [4, 3])
