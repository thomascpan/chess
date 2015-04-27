module Chess
	class Board
		attr_accessor :grid

		def initialize(grid = default_grid)
			@grid = grid
			@last_grid = "hello"
		end

		def formatted_grid
			puts "    A   B   C   D   E   F   G   H"
			grid.each_with_index do |row, index|
				puts "#{grid.length-index} #{row.map { |cell| cell.piece.nil? ? "[  ]" : "[#{cell.piece}#{cell.color}]" }.join("")}"
			end
		end

		def move_piece(old_pos, new_pos)
			record_grid
			x = grid[old_pos.first][old_pos.last]
			y = grid[new_pos.first][new_pos.last]
			color = x.color
			# Castling Condition
			if castling_condition?(x, color, old_pos, new_pos)
				grid[new_pos.first][new_pos.last] = grid[old_pos.first][old_pos.last]
				grid[new_pos.first][new_pos.last].moved = true
				grid[old_pos.first][old_pos.last] = Cell.new				
			# En Passant Condition
			elsif en_passant_condition?(x, color, old_pos, new_pos)
				grid[new_pos.first][new_pos.last] = grid[old_pos.first][old_pos.last]
				grid[new_pos.first][new_pos.last].moved = true
				grid[old_pos.first][old_pos.last] = Cell.new
			# Normal moves
			elsif possible_moves(x.piece, old_pos, color).include?(new_pos)
				grid[new_pos.first][new_pos.last] = grid[old_pos.first][old_pos.last]			
				grid[new_pos.first][new_pos.last].moved = true
				grid[old_pos.first][old_pos.last] = Cell.new
				if grid[new_pos.first][new_pos.last].piece == "P"
					if old_pos.first == new_pos.first - 2 || old_pos.first == new_pos.first + 2
						grid[new_pos.first][new_pos.last].double = true
					end
				end
			else
				puts "Invalid move! Please try again!(A)"
				# Will cause infinite loop because parameters don't change. Need to fix later. 
				# return move_piece(old_pos, new_pos)
				return false
			end
			# Check if self_check
			if check?(color)
				undo_move
				puts "Invalid move! Please try again!(B)"
				return false
			end
		end

		# place at begining of move_piece only for own pieces
		def double_refresh
			grid.flatten.each do |cell|
				if cell.piece == "P"
					cell.double = false
				end
			end
		end

		def game_over(color)
			if check?(color)
				return :winner if checkmate?(color)
				puts "Check!"
			end
			return :draw if stalemate?(color)
			false
		end

		def get_coordinates(cell_object)
			x = grid.index { |e| e.include?(cell_object) }
			y = grid[x].index { |e| e == cell_object }
			coordinates = [x, y]
			return coordinates
		end

		def record_grid
			@last_grid = Marshal::load(Marshal.dump(@grid.clone))
		end

		def undo_move
			@grid = @last_grid
		end

		# Method that determines if you've self_checked after your move. 
		def check?(color)
			# return true if king is checked
			# King info: 
			king_object = (grid.flatten.select { |cell| cell.piece == "K" && cell.color == color }).first
			x_king = grid.index { |e| e.include?(king_object) }
			y_king = grid[x_king].index { |e| e == king_object }
			king_coordinate = [x_king, y_king]
			# Create a list of enemy unit cell objects
			enemy_objects = (grid.flatten.select { |cell| cell.color != color && cell.color != nil })
			# Create a list of enemy unit cell object's coordinates
			enemy_coordinates = []
			enemy_objects.each do |cell_object|
				enemy_coordinates << get_coordinates(cell_object)
			end
			enemies_possible_moves = []
			# Select moves that are not included in enemy's possible moves. 
			enemy_coordinates.each do |coordinates|
				enemy_piece = grid[coordinates.first][coordinates.last].piece
				enemy_color = grid[coordinates.first][coordinates.last].color
				enemies_possible_moves << possible_moves(enemy_piece, coordinates, enemy_color)
			end
			enemies_possible_moves.delete([])
			enemies_possible_moves.flatten!(1)
			return true if enemies_possible_moves.include?(king_coordinate)
			false
		end

		# Method that determiens if you've been check-mated by your enemy
		def checkmate?(color)
			# King info: 
			king_object = (grid.flatten.select { |cell| cell.piece == "K" && cell.color == color }).first
			x_king = grid.index { |e| e.include?(king_object) }
			y_king = grid[x_king].index { |e| e == king_object }
			king_coordinate = [x_king, y_king]
			# Conditions:
			# King's possible moves will also be in check
			return false if possible_moves_check?(king_coordinate, color) == false
			# No one can block or kill enemy checker
			return false if block?(color) == true
			true
		end

		def possible_moves_check?(king_coordinate, color)
			king_possible_moves = possible_moves("K", king_coordinate, color)
			enemy_objects = (grid.flatten.select { |cell| cell.color != color && cell.color != nil })
			# Create a list of enemy unit cell object's coordinates
			enemy_coordinates = []
			enemy_objects.each do |cell_object|
				enemy_coordinates << get_coordinates(cell_object)
			end
			enemies_possible_moves = []
			# Select moves that are not included in enemy's possible moves. 
			enemy_coordinates.each do |coordinates|
				enemy_piece = grid[coordinates.first][coordinates.last].piece
				enemy_color = grid[coordinates.first][coordinates.last].color
				enemies_possible_moves << possible_moves(enemy_piece, coordinates, enemy_color)
			end
			enemies_possible_moves.delete([])
			enemies_possible_moves.flatten!(1)
			king_possible_moves.all? do |e|
				enemies_possible_moves.include?(e)
			end
		end

		# Find the checker except for knight. get the position of the checker and the position of the king. Create a list of all coordinates between the two.
		# Determine if any own unit possible moves can go there. If unit blocking check is moved, it will call it an invalid move still. 
		def block?(color)
			# King info: 
			king_object = (grid.flatten.select { |cell| cell.piece == "K" && cell.color == color }).first
			x_king = grid.index { |e| e.include?(king_object) }
			y_king = grid[x_king].index { |e| e == king_object }
			king_coordinate = [x_king, y_king]
			# Create a list of enemy unit cell objects
			enemy_objects = (grid.flatten.select { |cell| cell.color != color && cell.color != nil })
			# Create a list of enemy unit cell object's coordinates
			enemy_coordinates = []
			enemy_objects.each do |cell_object|
				enemy_coordinates << get_coordinates(cell_object)
			end
			# Select moves that are not included in enemy's possible moves.
			enemy_checker = enemy_coordinates.find do |coordinates|
				enemy_piece = grid[coordinates.first][coordinates.last].piece
				enemy_color = grid[coordinates.first][coordinates.last].color
				possible_moves(enemy_piece, coordinates, enemy_color).include?(king_coordinate)
			end

			list = []
			# horizontal
			if grid[enemy_checker.first][enemy_checker.last].piece == "k"
				list = [[enemy_checker]]
			elsif king_coordinate.first == enemy_checker.first
				if king_coordinate.last < enemy_checker.last 
					list = (king_coordinate.last..enemy_checker.last).to_a
					list.map! { |e| e = [king_coordinate.first, e] }
				else
					list = (enemy_checker.last..king_coordinate.last).to_a
					list.map! { |e| e = [king_coordinate.first, e]}
				end
			# vertical
			elsif king_coordinate.last == enemy_checker.last
				if king_coordinate.first < enemy_checker.first 
					list = (king_coordinate.first..enemy_checker.first).to_a
					list.map! { |e| e = [e, king_coordinate.last] }
				else
					list = (enemy_checker.first..king_coordinate.first).to_a
					list.map! { |e| e = [e, king_coordinate.last]}
				end
			# Diagonal
			else 
				if king_coordinate.first < enemy_checker.first
					if king_coordinate.last < enemy_checker.last
						a = (king_coordinate.first..enemy_checker.first).to_a
						b = (king_coordinate.last..enemy_checker.last).to_a
					else
						a = (king_coordinate.first..enemy_checker.first).to_a
						b = (enemy_checker.last..king_coordinate.last).to_a.reverse
					end
				else
					if enemy_checker.last < king_coordinate.last 
						a = (enemy_checker.first..king_coordinate.first).to_a
						b = (enemy_checker.last..king_coordinate.last).to_a
					else
						a = (enemy_checker.first..king_coordinate.first).to_a
						b = (king_coordinate.last..enemy_checker.last).to_a.reverse
					end
				end
				list = a.each_with_index.map { |e, i| e = [e, b[i]] }
			end
			list.delete(king_coordinate)

			my_objects = (grid.flatten.select { |cell| cell.color == color && cell.piece != "K"})
			# Create a list of enemy unit cell object's coordinates
			my_coordinates = []
			my_objects.each do |cell_object|
				my_coordinates << get_coordinates(cell_object)
			end
			my_possible_moves = []
			# Select moves that are not included in enemy's possible moves. 
			my_coordinates.each do |coordinates|
				my_piece = grid[coordinates.first][coordinates.last].piece
				my_color = grid[coordinates.first][coordinates.last].color
				my_possible_moves << possible_moves(my_piece, coordinates, my_color)
			end
			my_possible_moves.delete([])
			my_possible_moves.flatten!(1)
			list.each do |e|
				return true if my_possible_moves.include?(e)
			end
			false
		end

		private

		def default_grid
			# Create cell in each coordinate
			temp = Array.new(8) { Array.new(8) { Cell.new }}
			# Assign 0th row color
			temp[0].each { |cell| cell.color = "B"}
			# Assign 0th row pieces
			temp[0][0].piece = "R"
			temp[0][1].piece = "k"
			temp[0][2].piece = "B"
			temp[0][3].piece = "Q"
			temp[0][4].piece = "K"
			temp[0][5].piece = "B"
			temp[0][6].piece = "k"
			temp[0][7].piece = "R"
			# Assign 1st row pieces and color
			temp[1].each do |cell|
				cell.piece = "P"
				cell.color = "B"
			end
			# Assign 6th row pieces and color
			temp[6].each do |cell|
				cell.piece = "P"
				cell.color = "W"
			end
			# Assign 7th row color
			temp[7].each { |cell| cell.color = "W"}			
			# Assign 7th row pieces
			temp[7][0].piece = "R"
			temp[7][1].piece = "k"
			temp[7][2].piece = "B"
			temp[7][3].piece = "Q"
			temp[7][4].piece = "K"
			temp[7][5].piece = "B"
			temp[7][6].piece = "k"
			temp[7][7].piece = "R"
			return temp
		end

		def possible_moves(piece, position, color)
			x = position.first
			y = position.last
			case piece
			when "P"
				if color == "W"
					moves = [
						[x-1, y],
						[x-2, y]
					]
					moves.pop if grid[x][y].moved || grid[x-2][y].piece != nil
					moves.delete_at(0) if grid[x-1][y] != nil
					unless grid[x-1][y-1].nil? 
						moves << [x-1, y-1] if grid[x-1][y-1].piece != nil
					end
					unless grid[x-1][y+1].nil?		
						moves << [x-1, y+1] if grid[x-1][y+1].piece != nil
					end
				elsif color == "B"
					moves = [
						[x+1, y],
						[x+2, y]
					]
					moves.pop if grid[x][y].moved || grid[x+2][y].piece != nil
					moves.delete_at(0) if grid[x+1][y] != nil
					unless grid[x+1][y-1].nil?
						moves << [x+1, y-1] if grid[x+1][y-1].piece != nil
					end
					unless grid[x+1][y+1].nil?
						moves << [x+1, y+1] if grid[x+1][y+1].piece != nil
					end
				else
				end
			when "R"
				up_move = [
					[x-1, y],[x-2, y],
					[x-3, y],[x-4, y],
					[x-5, y],[x-6, y],
					[x-7, y]
				]
				up_move = rook_filter(up_move, color)
				down_move = [
					[x+1, y],[x+2, y],
					[x+3, y],[x+4, y],
					[x+5, y],[x+6, y],
					[x+7, y]
				]
				down_move = rook_filter(down_move, color)
				left_move = [
					[x, y-1],[x, y-2],
					[x, y-3],[x, y-4],
					[x, y-5],[x, y-6],
					[x, y-7]
				]
				left_move = rook_filter(left_move, color)
				right_move = [
					[x, y+1],[x, y+2],
					[x, y+3],[x, y+4],
					[x, y+5],[x, y+6],
					[x, y+7]
				]
				right_move = rook_filter(right_move, color)
				moves = up_move + down_move + left_move + right_move
			when "k"
				moves = [
					[x-1,y+2],[x+1,y+2],
					[x-2,y+1],[x+2,y+1],
					[x-2,y-1],[x-1,y-2],
					[x+2,y-1],[x+1,y-2]
				]
			when "B"
				ne_move = [
					[x-1,y+1],[x-2,y+2],
					[x-3,y+3],[x-4,y+4],
					[x-5,y+5],[x-6,y+6],
					[x-7,y+7],
				]
				ne_move = bishop_filter(ne_move, color)
				se_move = [
					[x+1,y+1],[x+2,y+2],
					[x+3,y+3],[x+4,y+4],
					[x+5,y+5],[x+6,y+6],
					[x+7,y+7],
				]
				se_move = bishop_filter(se_move, color)	
				sw_move = [
					[x+1,y-1],[x+2,y-2],
					[x+3,y-3],[x+4,y-4],
					[x+5,y-5],[x+6,y-6],
					[x+7,y-7],
				]
				sw_move = bishop_filter(sw_move, color)	
				nw_move = [
					[x-1,y-1],[x-2,y-2],
					[x-3,y-3],[x-4,y-4],
					[x-5,y-5],[x-6,y-6],
					[x-7,y-7],
				]
				nw_move = bishop_filter(nw_move, color)
				moves = ne_move + se_move + sw_move + nw_move				
			when "Q"
				ne_move = [
					[x-1,y+1],[x-2,y+2],
					[x-3,y+3],[x-4,y+4],
					[x-5,y+5],[x-6,y+6],
					[x-7,y+7],
				]
				ne_move = bishop_filter(ne_move, color)
				se_move = [
					[x+1,y+1],[x+2,y+2],
					[x+3,y+3],[x+4,y+4],
					[x+5,y+5],[x+6,y+6],
					[x+7,y+7],
				]
				se_move = bishop_filter(se_move, color)	
				sw_move = [
					[x+1,y-1],[x+2,y-2],
					[x+3,y-3],[x+4,y-4],
					[x+5,y-5],[x+6,y-6],
					[x+7,y-7],
				]
				sw_move = bishop_filter(sw_move, color)	
				nw_move = [
					[x-1,y-1],[x-2,y-2],
					[x-3,y-3],[x-4,y-4],
					[x-5,y-5],[x-6,y-6],
					[x-7,y-7],
				]
				nw_move = bishop_filter(nw_move, color)				
				up_move = [
					[x-1, y],[x-2, y],
					[x-3, y],[x-4, y],
					[x-5, y],[x-6, y],
					[x-7, y]
				]
				up_move = rook_filter(up_move, color)
				down_move = [
					[x+1, y],[x+2, y],
					[x+3, y],[x+4, y],
					[x+5, y],[x+6, y],
					[x+7, y]
				]
				down_move = rook_filter(down_move, color)
				left_move = [
					[x, y-1],[x, y-2],
					[x, y-3],[x, y-4],
					[x, y-5],[x, y-6],
					[x, y-7]
				]
				left_move = rook_filter(left_move, color)
				right_move = [
					[x, y+1],[x, y+2],
					[x, y+3],[x, y+4],
					[x, y+5],[x, y+6],
					[x, y+7]
				]
				right_move = rook_filter(right_move, color)
				moves = up_move + down_move + left_move + right_move + ne_move + se_move + sw_move + nw_move						
			when "K"
				moves = [
					[x+1,y],[x-1,y],
					[x,y+1],[x,y-1],
					[x+1,y+1],[x+1,y-1],
					[x-1,y+1],[x-1,y-1]
				]
				moves
			end
			moves.select! { |move| move[0] >= 0 && move[0] <= 7 && move[1] >= 0 && move[1] <= 7 }
			moves.select! { |move| grid[move.first][move.last].color != color }	
			moves
		end

		def stalemate?(color)
			return false if check?(color) == true
			my_objects = (grid.flatten.select { |cell| cell.color == color })
			# Create a list of enemy unit cell object's coordinates
			my_coordinates = []
			my_objects.each do |cell_object|
				my_coordinates << get_coordinates(cell_object)
			end
			my_possible_moves = []
			# Select moves that are not included in enemy's possible moves. 
			my_coordinates.each do |coordinates|
				my_piece = grid[coordinates.first][coordinates.last].piece
				my_color = grid[coordinates.first][coordinates.last].color
				my_possible_moves << possible_moves(my_piece, coordinates, my_color)
			end
			my_possible_moves.delete([])
			my_possible_moves.flatten!(1)
			enemy_objects = (grid.flatten.select { |cell| cell.color != color && cell.color != nil })
			# Create a list of enemy unit cell object's coordinates
			enemy_coordinates = []
			enemy_objects.each do |cell_object|
				enemy_coordinates << get_coordinates(cell_object)
			end
			enemies_possible_moves = []
			# Select moves that are not included in enemy's possible moves. 
			enemy_coordinates.each do |coordinates|
				enemy_piece = grid[coordinates.first][coordinates.last].piece
				enemy_color = grid[coordinates.first][coordinates.last].color
				enemies_possible_moves << possible_moves(enemy_piece, coordinates, enemy_color)
			end
			enemies_possible_moves.delete([])
			enemies_possible_moves.flatten!(1)
			my_possible_moves.all? do |e|
				enemies_possible_moves.include?(e)
			end			
		end

		def rook_filter(array, color)
			temp = []
			array.each do |move|
				break if grid[move.first].nil?
				break if grid[move.first][move.last].nil?				
				x = grid[move.first][move.last]
				if x.color != nil && x.color != color
					temp << move
					break
				elsif x.color.nil?
					temp << move
				else
					break
				end
			end
			return temp
		end

		def bishop_filter(array, color)
			temp = []
			array.each do |move|
				break if grid[move.first].nil?
				break if grid[move.first][move.last].nil?
				x = grid[move.first][move.last]
				if x.color != nil && x.color != color
					temp << move
					break
				elsif x.color.nil?
					temp << move
				else
					break
				end
			end
			return temp
		end

		def castling_condition?(unit, color, old_pos, new_pos)
			return false if unit.piece != "K"
			if unit.color == "B"
				if new_pos.last == old_pos.last + 2 && grid[0][5].piece.nil? && grid[0][6].piece.nil? && grid[0][7].moved == false
					grid[0][5] = grid[0][7]
					grid[0][5].moved = true
					grid[0][7] = Cell.new
					return true
				elsif new_pos.last == old_pos.last - 2 && grid[0][3].piece.nil? && grid[0][2].piece.nil? && grid[0][1].piece.nil? && grid[0][0].moved == false
					grid[0][3] = grid[0][0]
					grid[0][3].moved = true
					grid[0][0] = Cell.new					
					return true
				end
			elsif unit.color == "W"
				if new_pos.last == old_pos.last + 2 && grid[7][5].piece.nil? && grid[7][6].piece.nil? && grid[7][7].moved == false
					grid[7][5] = grid[7][7]
					grid[7][5].moved = true
					grid[7][7] = Cell.new					
					return true
				elsif new_pos.last == old_pos.last - 2 && grid[7][3].piece.nil? && grid[7][2].piece.nil? && grid[7][1].piece.nil? && grid[7][0].moved == false
					grid[7][3] = grid[7][0]
					grid[7][3].moved = true
					grid[7][0] = Cell.new					
					return true
				end
			end
			return false
		end

		# Method to set all cell.double back to false. For en-passant
		def en_passant_condition?(unit, color, old_pos, new_pos)
			return false if unit.piece != "P"
			return false if new_pos.last == old_pos.last
			current_pos = grid[old_pos.first][old_pos.last]
			potential_target = @grid[old_pos.first][new_pos.last]
			if potential_target.piece == "P" && potential_target.double == true
				grid[old_pos.first][new_pos.last] = Cell.new
				return true
			else
				return false
			end
		end
	end
end