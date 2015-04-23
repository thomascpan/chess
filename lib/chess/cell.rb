module Chess
	class Cell
		attr_accessor :piece, :color, :moved, :double

		def initialize(piece = nil, color = nil)
			@piece = piece
			@color = color
			@moved = false
			@double = false
		end
	end
end