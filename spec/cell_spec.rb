require "spec_helper"

module Chess
	describe Cell do
		let(:cell) { Cell.new }
		context "#initialize" do
			it "creates a new Cell object" do
				expect(cell).to be_instance_of Cell
			end

			it "initializes a value of 'nil' by default" do
				expect(cell.piece).to eq nil
				expect(cell.color).to eq nil
			end

			it "initializes a value of 'X'" do
				cell_with_value = Cell.new("K", "B")
				expect(cell_with_value.piece).to eq "K"
				expect(cell_with_value.color).to eq "B"
			end
		end
	end
end