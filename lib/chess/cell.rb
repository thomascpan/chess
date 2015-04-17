module Chess
	class Cell
		attr_accessor :piece, :color, :moved

		def initialize(piece = nil, color = nil)
			@piece = piece
			@color = color
			@moved = false
		end
	end
end