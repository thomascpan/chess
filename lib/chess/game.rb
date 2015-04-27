module Chess
	class Game
		attr_reader :players, :board, :current_player, :other_player

		def initialize(players, board = Board.new)
			@players = players
			@board = board
			@current_player, @other_player = players.shuffle
		end

		def menu
			puts introduction
			user_input = gets.chomp

			case user_input.downcase
				when 'l'
					load_game
				when 's'
					new_game
				when 'q'
					puts "Thanks for playing\n"
					return
				when 'd'
					delete_game
				else
					puts "Invalid entry!\n\n"
					return menu
			end
		end

		def switch_players
			@current_player, @other_player = @other_player, @current_player
		end

		def instructions
			"Input Format: Letter followed by Number. Ex.(a1)"
		end

		def solicit_move_a
			"#{current_player.name}(#{current_player.color}): Please select a piece. (enter 'save' to save the game)"
		end

		def solicit_move_b
			"#{current_player.name}(#{current_player.color}): Where would you like to move your piece?"
		end

		def get_move(first = false, human_move = gets.chomp)
			human_move = human_move.split('')
			human_move[0] = human_move_to_coordinate(human_move[0])
			human_move[1] = human_move_to_coordinate(human_move[1])
			human_move.reverse!
			if first == true
				if current_player.color != board.grid[human_move.first][human_move.last].color
					puts "Cannot select opposing player's piece. Please try again!\n\n"
					puts solicit_move_a
					return get_move(true)
				end
			end
			human_move
		end

		def play
			puts instructions
			puts
			puts "#{current_player.name.capitalize}(#{current_player.color}) has randomly been selected to go first."
			while true
				board.formatted_grid
				puts solicit_move_a
				old_pos = get_move(true)
				puts
				puts solicit_move_b
				new_pos = get_move
				puts
				next if board.move_piece(old_pos, new_pos) == false
				if board.game_over(other_player.color)
					puts game_over_message(other_player.color)
					board.formatted_grid
					return
				else
					switch_players
				end
			end
		end

		private

		def introduction
			"Welcome to Chess!\n\n Do you want to (l)oad a game, (s)tart a new game, (d)elete a game, or (q)uit.\n"
		end		

		def game_over_message(color)
			return "Checkmate! #{current_player.name} won!" if board.game_over(color) == :winner
			return "Stalemate! The game ended in a draw" if board.game_over(color) == :draw
		end		

		def human_move_to_coordinate(input)
			mapping = {
				"1" => 7,
				"2" => 6,
				"3" => 5,
				"4" => 4,
				"5" => 3,
				"6" => 2,
				"7" => 1,
				"8" => 0,
				"a" => 0,
				"b" => 1,
				"c" => 2,
				"d" => 3,
				"e" => 4,
				"f" => 5,
				"g" => 6,
				"h" => 7
			}
			mapping[input]
		end
	end
end