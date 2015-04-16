module Chess
	class Cell
		attr_accessor :piece, :color

		def initialize(piece = nil, color = nil)
			@piece = piece
			@color = color
		end
	end
end