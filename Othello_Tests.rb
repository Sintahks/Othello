require './Othello'
require 'test/unit'

class TestGame < Test::Unit::TestCase 
	
	def test_make_move
		# Calls a method in Board that places a piece in the given index
		# Converts @skipped to false. 
		#@board.make_move(20)
		#==>@board.board[20]= $current_player
	end 
	
	def test_game_ended?
		# Checks if the game has ended
		# @game.game_ended?
		#==>true (if game has ended)
		#==>false (if game has not ended)
	end 
	
	def test_end_game
		# Converts @game_ended to true
		game = Game.new(Board.new())
		assert_equal(true, game.end_game())
	end 
	
	def test_skip
		# If previous player skipped, ends the game
		# If previous player DIDN'T skip, switches player.
		# @game.skip
		#==> $current_player= @player2 (switches the player)
		#==> @game.end_game 		(ends the game if there are two consecutive skips)
	end 
	
	# Counts the pieces of player 1
	# Each player starts with 2 pieces on the board. 
	def test_player1_count
		game = Game.new(Board.new())
		assert_equal(2, game.player1_count())
	end 
	
	# Counts the pieces of player 2
	# Each player starts with 2 pieces on the board. 
	def test_player2_count
		game = Game.new(Board.new())
		assert_equal(2, game.player2_count()) 
	end 
	
	# Since both players have the same amount of pieces, there is no winner. 
	def test_show_winner
		game = Game.new(Board.new())
		assert_equal(nil, game.show_winner())
	end 
	
	# Current player at the beginning is player1. 
	def test_switch_player
		game = Game.new(Board.new())
		assert_equal(game.player2, game.switch_player())
	end 
		
end 

class TestBoard < Test::Unit::TestCase 
	def test_valid_move?
		board = Board.new()
		game = Game.new(board)
		assert_equal(false, board.valid_move?(19)) 
		assert_equal(true, board.valid_move?(20))
	end 
	
	def test_convert_pieces
		# Given an array of indencies, converts contents to piece of current player. 
		# convert_pieces([1,2,3])
		#==> board.board[1] = $current_player
		#==> board.board[2] = $current_player
		#==> board.board[3] = $current_player
	end 
	
	def test_passed_left_edge?
		board=Board.new()
		assert_equal(false, board.passed_left_edge?(0))
		assert_equal(true , board.passed_left_edge?(7))
	end 
	
	def test_passed_right_edge?
		board= Board.new()
		assert_equal(true, board.passed_right_edge?(8))
		assert_equal(false, board.passed_right_edge?(2))
	end 
	
	def test_empty_space?
		board= Board.new()
		assert_equal(true, board.empty_space?(0))
		assert_equal(false, board.empty_space?(27))
	end 
	
	def test_in_bounds?
		board= Board.new()
		assert_equal(true, board.in_bounds?(1))
		assert_equal(false, board.in_bounds?(-100))
	end 
	
	def test_conversion?
		# Given a direction and array, determines if the pieces are eligible to be converted
		board=Board.new()
		board.make_move(5)
		assert_equal(true, board.conversion?("left", [6]))
		assert_equal(false, board.conversion?("left", [11,10,9]))
		assert_equal(true, board.conversion?("right", [1,2,3,4]))
		assert_equal(false, board.conversion?("right", []))
		assert_equal(true, board.conversion?("up", [37,29,21,13]))
		assert_equal(false, board.conversion?("up", [39,31,23]))
		assert_equal(true, board.conversion?("RUD",[26, 19, 12]))
		assert_equal(false, board.conversion?("RUD", [53,39]))
		assert_equal(true, board.conversion?("LUD", [14]))
		assert_equal(false, board.conversion?("LUD", [53,54]))
		board.make_move(61)
		assert_equal(true, board.conversion?("RDD", [34,43,52]))
		assert_equal(false, board.conversion?("RDD", [49]))
		assert_equal(true, board.conversion?("LDD", [54]))
		assert_equal(false, board.conversion?("LDD", [46,53]))
	end 
	
	def test_check_RUPDiag
		board=Board.new()
		assert_equal([35,28], board.check_RUpDiag(42))
		assert_equal([], board.check_RUpDiag(0))
	end 
	
	def test_check_RDownDiag
		board=Board.new()
		assert_equal([28], board.check_RDownDiag(19))
		assert_equal([], board.check_RDownDiag(56))
	end 
	
	def test_check_LUpDiag
		board=Board.new()
		assert_equal([28], board.check_LUpDiag(37))
		assert_equal([], board.check_LUpDiag(0))
	end 
	
	def test_check_LDownDiag
		board=Board.new()
		assert_equal([28,35], board.check_LDownDiag(21))
		assert_equal([], board.check_LDownDiag(0))
	end 
	
	def test_check_up
		board=Board.new()
		game = Game.new(board)
		assert_equal([35], board.check_up(43))
		assert_equal([], board.check_up(0))
	end 
	
	def test_check_down
		board=Board.new()
		game = Game.new(board)
		assert_equal([28], board.check_down(20))
		assert_equal([], board.check_down(63))
	end 
	
	def test_check_right
		board=Board.new()
		game = Game.new(board)
		assert_equal([35], board.check_right(34))
		assert_equal([], board.check_right(7))
	end 
	
	def test_check_left
		board=Board.new()
		game = Game.new(board)
		assert_equal([28], board.check_left(29))
		assert_equal([], board.check_left(0))
	end 
	
	def test_cp_piece?
		board= Board.new()
		game = Game.new(board)
		assert_equal(true, board.cp_piece?(27))
		assert_equal(false, board.cp_piece?(28))
	end 
	
	def test_any_converted_pieces?
		board= Board.new()
		game = Game.new(board)
		assert_equal(true, board.any_converted_pieces?(43))
		assert_equal(false, board.any_converted_pieces?(44))
	end 
		
end 


