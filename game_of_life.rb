require 'pry'

class GameOfLife

  def initialize
    @board = []
    @columns = 80
    @rows = 20
    @neighbours = [-1, 1, @columns, -@columns, @columns - 1, @columns + 1, -@columns + 1, -@columns - 1]
    @genWeighting = 0.05 # sets start weighting for generation 0=Off 1=On
    initBoard
  end

  # initialise board. create array with columns * rows dimensions
  def initBoard
    cellNum = 0
    while cellNum < (@columns * @rows)
      @board.push(rand < @genWeighting ? 1 : 0)
      cellNum += 1
    end
    @board
  end

  # generate new iteration every 0.5s
  def generate
    generations = 0
    loop do
      print
      sleep(0.5)
      newGeneration
      generations += 1
      p "Number of generations: #{generations}  [Ctrl-C to exit]"
    end
  end

  # print board to console with \n at end each row.
  def print
    displayBoard = []
    @board.each_with_index { |elem, index|
      if index % @columns == 0
        displayBoard.push("\n")
      end
      displayBoard.push(elem)
    }
    puts displayBoard.join
  end

  # calculate new generation
  # get cell score based on neighbour statuses (checkNeighbours)
  # Get new cell state based on score (newCellState)
  def newGeneration
    cellScore = 0
    cellState = 0
    newBoard = []
    @board.each_with_index { |elem, index|
      cellScore = checkNeighbours(index)
      cellState = newCellState(index, cellScore)
      newBoard.push(cellState)
    }
    @board = newBoard
  end

  # Checking each neighbour state. Tabulate a score
  def checkNeighbours(cellIndex)
    cellScore = 0
    cellTotal = 0
    @neighbours.each { |neighbour|
      (@board[cellIndex + neighbour]).to_f.nan? ?
      cellScore = 0 :
      cellScore = @board[cellIndex + neighbour]
      cellTotal += cellScore.to_i
    }
    return cellTotal
  end

  # Cell dies unless neighbour score is 2-3 OR dead cell has neighbour score ==3
  def newCellState(cellIndex, cellScore)
    newCellState = 0
    cellScore == 2 || cellScore == 3 && @board[cellIndex] ? newCellState = 1 : newCellState = 0
    if cellScore == 3 && @board[cellIndex] == 0
      newCellState = 1
    end
    return newCellState;
  end

end

game = GameOfLife.new()
game.generate
