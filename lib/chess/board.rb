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
				# use while and each to add only unobstructed coordinates
				# up_move.each do |move|
				# 	while true
				# 		if move.piece.nil?
				# 			moves << move
				# 		else
				# 			return false
				# 		end
				# 	end
				end
				down_move = [
					[x+1, y],[x+2, y],
					[x+3, y],[x+4, y],
					[x+5, y],[x+6, y],
					[x+7, y]
				]
				left_move = [
					[x, y-1],[x, y-2],
					[x, y-3],[x, y-4],
					[x, y-5],[x, y-6],
					[x, y-7]
				]
				right_move = [
					[x, y+1],[x, y+2],
					[x, y+3],[x, y+4],
					[x, y+5],[x, y+6],
					[x, y+7]
				]
				moves = up_move + down_move + left_move + right_move
			when "k"
				moves = [
					[x-1,y+2],[x+1,y+2],
					[x-2,y+1],[x+2,y+1],
					[x-2,y-1],[x-1,y-2],
					[x+2,y-1],[x+1,y-2]
				]
			when "B"
				moves = [
					[x+1,y+1],[x-1,y-1],[x+1,y-1],[x-1,y+1],
					[x+2,y+2],[x-2,y-2],[x+2,y-2],[x-2,y+2],
					[x+3,y+3],[x-3,y-3],[x+3,y-3],[x-3,y+3],
					[x+4,y+4],[x-4,y-4],[x+4,y-4],[x-4,y+4],
					[x+5,y+5],[x-5,y-5],[x+5,y-5],[x-5,y+5],
					[x+6,y+6],[x-6,y-6],[x+6,y-6],[x-6,y+6],
					[x+7,y+7],[x-7,y-7],[x+7,y-7],[x-7,y+7]
				]
			when "Q"
				moves = [
					[x+1,y+1],[x-1,y-1],[x+1,y-1],[x-1,y+1],
					[x+2,y+2],[x-2,y-2],[x+2,y-2],[x-2,y+2],
					[x+3,y+3],[x-3,y-3],[x+3,y-3],[x-3,y+3],
					[x+4,y+4],[x-4,y-4],[x+4,y-4],[x-4,y+4],
					[x+5,y+5],[x-5,y-5],[x+5,y-5],[x-5,y+5],
					[x+6,y+6],[x-6,y-6],[x+6,y-6],[x-6,y+6],
					[x+7,y+7],[x-7,y-7],[x+7,y-7],[x-7,y+7]
				] +
				[
					[x, 0],[0, y],
					[x, 1],[1, y],
					[x, 2],[2, y],
					[x, 3],[3, y],
					[x, 4],[4, y],
					[x, 5],[5, y],
					[x, 6],[6, y],
					[x, 7],[7, y]					
				]
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
			moves
		end
	end
end