require 'gosu'
require 'rubygems'
require './Othello'

# Makes a new Game (calls game class) and runs the game with chosen images
# '600,600' is the size of the image of the board. 
class GameWindow < Gosu::Window
	def initialize()
		super(600,600, false, 100)
		self.caption = "Othello"
		@board				= Board.new()
		@game 				= Game.new(@board)
		@background_image	= Gosu::Image.new(self, "background.jpg", true)
		@gray_dot			= Gosu::Image.new(self, "grayp.png", true) 
		@black_dot 			= Gosu::Image.new(self, "blackpp.png", true)
		@end_button			= Gosu::Image.new(self, "end_game_button.png", true)
		@skip_button		= Gosu::Image.new(self, "skip.png", true)
		@draw_game			= Gosu::Image.new(self, "draw.png", true)
		@blackwin			= Gosu::Image.new(self, "blackwin.png", true)
		@graywin			= Gosu::Image.new(self, "graywin.png", true)
		
	end
	
	# In order for user to end the game, they must click in the predefined boundaries of
	#   the end game image. 
	# Boundaries arise of region on the window the end game button covers. 
	def end_game_bounds?(x, y)
		x < 129 && y < 54
	end 
	
	# In order for the user to skip his/her turn, he/she must click anywhere between these boundaries
	# Boundaries arise from the region the skip button covers on the window. 
		#i.e. from x = (513, 600) and y= (0,50), is the region the skip button covers. 
	def skip_bounds?(x,y)
		x> 513 && y < 50 
	end 
	
	# In order from the user to make a move, she must click on a checkered space on the board.
	# All checkered spaces reside between these boundaries. 
			#NOTE: Notepad++ mistakenly believes checkered is mispelled when it is no. 
	def in_bound?(x ,y)
		x_pos = x
		y_pos = y 
		if x_pos < 64 || x_pos > 535 || y_pos < 64 || y_pos > 535
			return false
		else
			return true
		end 
	end 
	
	
	
	#Creates an index given a (mouse) position. 
	# 64 - x-value of the left hand corner of the board.
	# 64 - y-value of the left hand corner of the board. 
	# 59 - length/width of each square/checker. 
	# Numbers differ from below to handle edge cases of clicking. 
	# 8 - number of squares in a row 
	def to_ind(x, y)
		i = (((x.to_i-64)/59)+(8*(((mouse_y.to_i-64)/59))))
		return i 
	end 
	
	
	#Given an index, puts out an (x,y) position
	# 8 - number of squares in a row/ width of array 
	# 60 - length/width of each square 
	# 62 - approximate x and y position of left hand corner of the array.
	def to_posn(i)
		x = (((i%8)*60)+62)
		y = (((i/8)*60)+62)
		return [x, y]
	end
	
	
	# '0,0,0' places the image of the board at the center of the window. 
	def draw
		@background_image.draw(0,0,0)
		@board.board_arr.each{ |i|
								if @board.board[i] == " X "
									(x,y)= to_posn(i)
									@black_dot.draw(x, y, 2)  
								elsif @board.board[i] == " O "
									(x,y)= to_posn(i)
									@gray_dot.draw(x,y,2)
									
								end
						}
						
		# (200, 0, 2) Draws game results at the top center of the window 
		if @game.game_ended?
			case @game.show_winner()
			when " X "
				@blackwin.draw(200, 0, 2)
			when " O "
				@graywin.draw(200, 0, 2)
			when nil
				@draw_game.draw(200,0,2)
			end 
		end 
				
		# Draws the piece of the current player in below the curson 
		# ((mouse_x-20), (mouse_y-20)) places the image in the middle 
		if $current_player==@game.player1
			@black_dot.draw((mouse_x-20), (mouse_y-20), 2)
		else
			@gray_dot.draw((mouse_x-20), (mouse_y-20), 2)
		end 
		
		# (0, 0, 2) places the end button at left hand corner of the window. 
		@end_button.draw(0,0,2)
		
		# (513, 0, 2) places the skip button at the right hand corner of the window. 
		@skip_button.draw(513,0,2)
		
	end 
	

		
	# Allows user to see curson 	
	def needs_cursor?
		true
	end #needs_cursor?
	
	# Handles the appropriate action if a specific key is pressed
	# Allows user to use left mouse click to perform varous actions 
	def button_down(id)
		if id == Gosu::KbEscape
			close
		end 
			
		if id == Gosu::MsLeft
			index = to_ind(mouse_x, mouse_y)
			if in_bound?(mouse_x, mouse_y)
				if @game.game_ended?
					nil 
				elsif @board.valid_move?(index)
					@game.make_move(index)
					@game.switch_player()
				end 
			end 
			
			if end_game_bounds?(mouse_x, mouse_y)
				@game.end_game()
			end 
			if skip_bounds?(mouse_x, mouse_y)
				@game.skip()
			end 
		end 

		if id == Gosu::KbSpace
			reset
		end 
	end 
	
	#Resets the game
	def reset
		@board = Board.new()
		@game = Game.new(@board)
	end 
end  

game=GameWindow.new
game.show