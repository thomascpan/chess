require "spec_helper"

module Chess
	describe Board do
		let(:board) { Board.new }
		context "#initialize" do
			it "creates a Board object" do
				expect(board).to be_instance_of Board
			end

			it "initializes the board with a grid" do
				board_with_grid = Board.new("grid")
				expect{board_with_grid}.to_not raise_error
				expect(board_with_grid.grid).to eq "grid"
			end

			it "initialize with a default grid thats an Array object" do
				expect(board.grid).to be_instance_of Array
			end

			it "creates a default grid with a length of 8" do
				expect(board.grid.length).to eq 8
			end

			it "creates a default grid with each element having a length of 8" do
				board.grid.each do |row|
					expect(row.size).to eq 8
				end
			end
		end

		context "#move_piece" do
			it "selects and moves a piece to a new location" do
				board.move_piece([1,0], [3,0])
				expect(board.grid[1][0].piece).to eq nil
				expect(board.grid[1][0].color).to eq nil
				expect(board.grid[3][0].piece).to eq "P"
				expect(board.grid[3][0].color).to eq "B"
			end

			it "returns an error message if piece moves to another piece with same color" do
				expect(board.move_piece([0,2], [1,1])).to eq false
			end
		end

		# context "#select_piece" do
		# 	it "selects a piece" do
		# 		expect(board.select_piece(1,0)).to be_instance_of Cell
		# 		expect(board.select_piece(1,0)).to eq board.grid[1][0]
		# 	end
		# end
	end
end