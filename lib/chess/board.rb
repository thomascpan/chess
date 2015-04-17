module Chess
	class Board
		attr_reader :grid

		def initialize(grid = default_grid)
			@grid = grid			
		end

		def formatted_grid
			puts "    A   B   C   D   E   F   G   H"
			grid.each_with_index do |row, index|
				puts "#{index+1} #{row.map { |cell| cell.piece.nil? ? "[  ]" : "[#{cell.piece}#{cell.color}]" }.join("")}"
			end
		end

		# def select_piece(row,column)
		# 	grid[row][column]
		# end

		def move_piece(old_pos, new_pos)
			x = grid[old_pos.first][old_pos.last]
			y = grid[new_pos.first][new_pos.last]
			color = x.color
			if possible_moves(x.piece, old_pos, color).include?(new_pos)
				grid[new_pos.first][new_pos.last] = grid[old_pos.first][old_pos.last]
				grid[new_pos.first][new_pos.last].moved = true
				grid[old_pos.first][old_pos.last] = Cell.new
			else
				puts "Invalid move! Please try again!"
				false
			end
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
						[x-1, y-1],
						[x-1, y+1],
						[x-2, y]
					]
					moves.pop if grid[x][y].moved 
				elsif "B"
					moves = [
						[x+1, y],
						[x+1, y-1],
						[x+1, y+1],
						[x+2, y]
					]
					moves.pop if grid[x][y].moved 					
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
					[x,y+1],[x,y+1],
					[x+1,y+1],[x+1,y-1],
					[x-1,y+1],[x-1,y-1],
					[x, y+2],[x,y-2]
				]
				2.times { moves.pop } if grid[x][y].moved 					
			else
			end
			moves.select! { |move| move[0] >= 0 && move[0] <= 7 && move[1] >= 0 && move[1] <= 7 }
			moves.select! { |move| grid[move.first][move.last].color != color }
			print moves
			puts
			moves
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

	end
end