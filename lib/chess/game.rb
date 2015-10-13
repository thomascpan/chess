module Chess
	require 'yaml'

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

		def new_game
			new_game_setup
			game_control
		end

		def game_control
			while true
				board.formatted_grid
				puts solicit_move_a
				old_pos = get_move(true)
				puts
				puts solicit_move_b
				new_pos = get_move
				puts
				if board.move_piece(old_pos, new_pos) == false
					puts "Invalid move! Please try again!"
					next
				end
				if board.game_over(other_player.color)
					puts game_over_message(other_player.color)
					board.formatted_grid
					return menu
				else
					switch_players
				end
			end
		end		

			private

			def new_game_setup
				puts instructions
				puts 
				puts "#{current_player.name.capitalize}(#{current_player.color}) has randomly been selected to go first."
			end		

			def introduction
				"Welcome to Chess!\n\n Do you want to (l)oad a game, (s)tart a new game, (d)elete a game, or (q)uit.\n"
			end

			def switch_players
				@current_player, @other_player = @other_player, @current_player
			end

			def instructions
				"Input Format: Letter followed by Number. Ex.(a1)"
			end

			def solicit_move_a
				"#{current_player.name}(#{current_player.color}): Please select a piece. (enter 'save' to save the game or 'menu' to return back to menu)"
			end

			def solicit_move_b
				"#{current_player.name}(#{current_player.color}): Where would you like to move your piece?"
			end

			def get_move(first = false, human_move = gets.upcase.chomp)
				if human_move == 'save'
					save_game
					return menu
				end
				return menu if human_move == 'menu'
				if human_move !~ /[a-hA-H][0-9]/
					puts "Invalid Move"
					return get_move(true)
				end				
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

			def save_game
				yaml = YAML::dump(self)
				puts 'Enter save file name (no spaces please).'
				save = gets.chomp
				save_file = File.new("saves/#{save}.yaml", "w")
				save_file.write(yaml)
				save_file.close
			end

			def load_game
				saves = check_save_files
				puts saves

				puts "Enter the file name you wish to load. i.e 'hello.yaml'."
				load_file = gets.strip
				yaml = "saves/#{load_file}"
				if saves.include?(load_file)
					load = YAML::load_file(yaml)
					# return load.game_control
					return load.game_control
				end

				puts "Invalid file name.\n\n"
				return menu
			end

			def check_save_files
				saves = Dir.glob('saves/*')
				saves.map! {|e| e[6, e.length]}
				if saves.empty?
					puts 'No save files.'
					return menu
				end
				puts 'Current saves:'
				saves
			end

			def delete_game
				saves = check_save_files
				puts "Enter the file name you wish to delete."
				delete_file = gets.strip
				file = "saves/#{delete_file}"
				if saves.include?(file)
					File.delete(file)
					puts "File deleted successfully!"
				else
					puts "Invalid file name.\n\n"
				end
				return menu
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
					"A" => 0,
					"B" => 1,
					"C" => 2,
					"D" => 3,
					"E" => 4,
					"F" => 5,
					"G" => 6,
					"H" => 7
				}
				mapping[input]
			end
	end
end