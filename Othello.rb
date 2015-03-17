
class Game
		attr_reader :current_player, :player1, :player2
	
	# Players are represented as Strings. 
	# Dependency is injected.
	def initialize(board)
		@board 			= 	board
		@player1		=	" X " 
		@player2		= 	" O "
		$current_player	=	@player1
		@skipped		= false
		@game_ended		= false	
	end
	
	# Places the current player's piece on the board. 
	# Passes here first so the Game can know that the player DID NOT skip his turn. 
	# Once a move is made, the Game doesn't have to worry about ending the game in an event of two skipped turns. 
	def make_move(move)
		@board.make_move(move)
		@skipped=false
	end 
	
	# Checks if the game has ended. 
	 def game_ended?
		return @game_ended
	 end 
	
	# Ends the game
	def end_game()
		@game_ended=true 
	end 
	
	# Skips current player's turn UNLESS previous player skipped too. 
	# If two players consecutively skip, game ends. 
	def skip
		if @skipped==false 
			switch_player()
			@skipped = true 
		elsif @skipped==true 
			end_game()
		end 
	end 
	
	# Counts the pieces of player1. 
	def player1_count()
		@board.board.count(@player1)
	end 
	
	# Counts the pieces of player2. 
	def player2_count()
		@board.board.count(@player2)
	end
	
	# Returns the player who has the most pieces on the board. 
	def show_winner()
		if player1_count() > player2_count
			return @player1 
		elsif player2_count() > player1_count
			return @player2
		else 
			return nil 
		end
	end 
	
	#Switches the current player. 
	def switch_player()
		if $current_player == @player1
			$current_player = @player2
		else 
			$current_player = @player1
		end 
	end
end 

class Board 
		attr_reader :board, :skipped, :end_game, :board_arr
		
	# Creates a board with the initial preset pieces. 
	def initialize ()
		@board = [	" . ", " . ", " . ", " . ", " . ", " . ", " . ", " . ",
		
					" . ", " . ", " . ", " . ", " . ", " . " ," . ", " . ",
					
					" . ", " . ", " . ", " . ", " . ", " . ", " . ", " . ",
					
					" . ", " . ", " . ", " X ", " O ", " . ", " . ", " . ",
					
					" . ", " . ", " . ", " O ", " X ", " . ", " . ", " . ",
					
					" . ", " . ", " . ", " . ", " . ", " . ", " . ", " . ",
					
					" . ", " . ", " . ", " . ", " . ", " . ", " . ", " . ",
					
					" . ", " . ", " . ", " . ", " . ", " . ", " . ", " . "]
		@board_arr		= Array(0..@board.length-1)
		@board_height	= 8
		@board_width 	= 8
	end
	
	# Determines if a move is valid
	def valid_move?(move)
		if  in_bounds?(move) && empty_space?(move) && any_converted_pieces?(move)
			return true
		else 
			return false
		end 
	end
	
	# Places the current player's piece on the board. 
	def make_move(move)
		@board[move]= $current_player
	end 
	
	# Given an array of indecies, converts contents of the indencies to pieces of the current player.
	def convert_pieces(array)
		array.each{|x| @board[x]=$current_player}
	end 
	
	# Given the next index, determines if the index has passed the left edge of the board
	# Needed because the representation of the board is a 1-D array. (Not One Direction)
	def passed_left_edge?(nxt_spc)
		nxt_spc% @board_width == (@board_width-1)
	end 

	# Given the next index, determines if the index has passed the right edge of the board.
	# Needed because the representation of the board is a 1-D array. 
	def passed_right_edge?(nxt_spc)
		nxt_spc% @board_width==0
	end 
	
	# Given an index, determines if it's contents are empty.
	# In this case, " . " represents an empty space 
	def empty_space?(index)		#CHECKS IF GIVEN INDEX IS AN EMPTY SPACE
		@board[index] == " . "
	end

	# Determines if a given move is within the boundaries of the board.
	def in_bounds?(move)
		if move < @board.length && move >= 0
			return true 
		else 
			return false
		end 		
	end 
	
	# Given a direction and an array, determines if there are any eligible pieces to be converted. 
	# Array given consists of the indecies of the opposite player's pieces. 
	def conversion?(dir, array)
		right_edges=@board_arr.select{|x| passed_left_edge?(x)}
		left_edges=@board_arr.select{|x| passed_right_edge?(x)}
		top_edges= Array(0..@board_width-1)
		bottom_edges= Array(@board.length-@board_width..@board.length-1)
		
		if array.empty?
			return false
		else 
			case dir
			
			# If the opposite player's piece is at the top edge of the board, pieces are unable to be converted
			# (Current player's pieces must SURROUND opposite player's pieces to convert pieces)
			when "up"
				if top_edges.include?(array.last)
					return false
				elsif empty_space?(array.last-@board_height)
					return false 
				else
					return true
				end
				
			# If the opposite player's piece is at the bottom edge of the board, pieces are unable to be converted
			# (Current player's pieces must SURROUND opposite player's pieces to convert pieces)
			when "down"
				if bottom_edges.include?(array.last)
					return false
				elsif empty_space?(array.last+@board_height)
					return false
				else
					return true
				end
				
			# If the opposite player's piece is at the right edge of the board, pieces are unable to be converted
			# (Current player's pieces must SURROUND opposite player's pieces to convert pieces)
			when "right"
				if right_edges.include?(array.last)
					return false
				elsif empty_space?(array.last+1)
					return false
				else
					return true
				end 
				
			# If the opposite player's piece is at the left edge of the board, pieces are unable to be converted
			# (Current player's pieces must SURROUND opposite player's pieces to convert pieces)
			when "left"
				if left_edges.include?(array.last)
					return false
				elsif empty_space?(array.last-1)
					return false
				else
					return true 
				end 
			
			# Right Upward Diagonal
			# If the opposite player's piece is at the right edge or top edge of the board, pieces are unable to be converted
			# Because we are checking RIGHT UPWARD diagonally, we either reach the right edge or the top edge of the board. Rarely both. 
			# (Current player's pieces must SURROUND opposite player's pieces to convert pieces)
			when "RUD"
				if top_edges.include?(array.last)|| right_edges.include?(array.last)
					return false
				elsif empty_space?(array.last+1-@board_height)
					return false
				else
					return true
				end
			 
			# Right Downward Diagonal 
			# If the opposite player's piece is at the right edge or bottom edge of the board, pieces are unable to be converted
			# Because we are checking RIGHT DOWNWARD diagonally, we either reach the right edge or the bottom edge of the board. Rarely both. 
			# (Current player's pieces must SURROUND opposite player's pieces to convert pieces)
			when "RDD"
				if bottom_edges.include?(array.last) || right_edges.include?(array.last)
					return false
				elsif empty_space?(array.last+1+@board_height)
					return false
				else 
					return true
				end 
			 
			# Left Downward Diagonal
			# If the opposite player's piece is at the left edge or bottom edge of the board, pieces are unable to be converted
			# Because we are checking LEFT DOWNWARD diagonally, we either reach the right edge or the bottom edge of the board. Rarely both. 
			# (Current player's pieces must SURROUND opposite player's pieces to convert pieces)
			when "LDD"
				if bottom_edges.include?(array.last)|| left_edges.include?(array.last)
					return false
				elsif empty_space?(array.last-1+@board_height)
					return false
				else 
					return true 
				end 
			
			# Left Upward Diagonal
			# If the opposite player's piece is at the left edge or bottom edge of the board, pieces are unable to be converted
			# Because we are checking LEFT UPWARD diagonally, we either reach the left edge or the top edge of the board. Rarely both. 
			# (Current player's pieces must SURROUND opposite player's pieces to convert pieces)
			when "LUD"
				if top_edges.include?(array.last) || left_edges.include?(array.last)
					return false
				elsif empty_space?(array.last-1-@board_height)
					return false
				else 
					return true
				end 
			end 
		end 
	end 
		
		# Given a move, returns the indecies of the OPPOSITE player's pieces in the Right Upward Diagonal direction (if any). 
		def check_RUpDiag(move)
			nxt_spc= ((move-@board_height)+1)
			array= []
			until passed_right_edge?(nxt_spc)|| empty_space?(nxt_spc) || cp_piece?(nxt_spc) || (not in_bounds?(nxt_spc)) do
				array.push(nxt_spc)
				nxt_spc-=(@board_height-1)
			end
			return array
		end
		
		# Given a move, returns the indecies of the OPPOSITE player's pieces in the Right Downward Diagonal direction (if any). 
		def check_RDownDiag(move)
			nxt_spc= ((move+@board_height)+1)
			array= []
			until passed_right_edge?(nxt_spc)|| empty_space?(nxt_spc) || cp_piece?(nxt_spc) || (not in_bounds?(nxt_spc)) do
				array.push(nxt_spc)
				nxt_spc+=(@board_height+1)
			end
			return array
		end
		# Given a move, returns the indecies of the OPPOSITE player's pieces in the Left Upward Diagonal direction (if any).
		def check_LUpDiag(move)
			nxt_spc= ((move-@board_height)-1)
			array=[]
			until passed_left_edge?(nxt_spc)|| empty_space?(nxt_spc)|| cp_piece?(nxt_spc) || (not in_bounds?(nxt_spc)) do
				array.push(nxt_spc)
				nxt_spc-=(@board_height+1)
			end
			return array
		end 
		
		
		# Given a move, returns the indecies of the OPPOSITE player's pieces in the Left Downward Diagonal direction (if any).
		def check_LDownDiag(move)
			nxt_spc=((move+@board_height)-1)
			array = []
			until passed_left_edge?(nxt_spc) || empty_space?(nxt_spc)|| cp_piece?(nxt_spc)|| (not in_bounds?(nxt_spc)) do
				array.push(nxt_spc)
				nxt_spc+=(@board_height-1)
			end
			return array
		end
		
		# Given a move, returns the indecies of the OPPOSITE player's pieces in the Rightward direction (if any). 
	def check_right(move)
		nxt_spc= move+1
		array=[]
		until passed_right_edge?(nxt_spc) || empty_space?(nxt_spc) || cp_piece?(nxt_spc) do
			array.push(nxt_spc)
			nxt_spc+=1
		end
		return array
	end 

		# Given a move, returns the indecies of the OPPOSITE player's pieces in the Leftward direction (if any). 
	def check_left(move)
		nxt_spc= move-1
		array=[]
		until passed_left_edge?(nxt_spc) || empty_space?(nxt_spc) || cp_piece?(nxt_spc) do
			array.push(nxt_spc)
			nxt_spc-=1
		end
		print array
		return array
	end 
		# Given a move, returns the indecies of the OPPOSITE player's pieces in the Upward direction (if any). 
	def check_up(move)
		nxt_spc= (move-@board_height)
		array= []
		until (not in_bounds?(nxt_spc))|| empty_space?(nxt_spc) || cp_piece?(nxt_spc) do
			array.push(nxt_spc)
			nxt_spc-=@board_height 
		end
		return array
	end
		# Given a move, returns the indecies of the OPPOSITE player's pieces in the Downward direction (if any). 
	def check_down(move)
		nxt_spc=(move+@board_height)
		array = []
		until (not in_bounds?(nxt_spc))|| empty_space?(nxt_spc)|| cp_piece?(nxt_spc) do 
			array.push(nxt_spc)
			nxt_spc+=@board_height
		end
		return array
	end 
	
	# Given an index, determines if it's contents are that of the current player. 
 	def cp_piece?(index)
		if index==nil
			return false
		else 
			@board[index]== $current_player
		end 
	end
	
	# Given a move, determines if there are ANY conversions in ANY direction. 
	def any_converted_pieces?(move)
		 right		=	["right", check_right(move)]
		 left		=	["left", check_left(move)]
		 up			=	["up", check_up(move)]
		 down		=	["down", check_down(move)]
		 rud		=	["RUD", check_RUpDiag(move)]
		 rdd		=	["RDD", check_RDownDiag(move)]
		 lud		=	["LUD", check_LUpDiag(move)]
		 ldd		=	["LDD", check_LDownDiag(move)]
		 directions	= 	[right, left, up, down, rud, rdd, lud, ldd]
		 valid_move	= 	false
		 directions.each do |dir, arr|
			if conversion?(dir, arr)
				convert_pieces(arr)
				valid_move= true
			end 
		 end
		return valid_move
	end 
	
end 
