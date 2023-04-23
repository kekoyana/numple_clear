require './board'
require './square'

board = Board.new
board.strings = (%w[
030605020
506000307
000020000
000801000
000904000
070000090
200406001
008000500
100703009
])

board.check
puts board.to_s
