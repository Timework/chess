class Piece
end
class White_Rook < Piece
    attr_reader :color, :symbol
    def initialize
        @color = "white"
        @symbol = ("\u2656")
    end
end
class White_Pawn < Piece
    attr_reader :color, :symbol
    attr_accessor :first
    def initialize
        @color = "white"
        @symbol = ("\u2659")
        @first = true
    end
end
class White_Bishop < Piece
    attr_reader :color, :symbol
    def initialize
        @color = "white"
        @symbol = ("\u2657")
    end
end
class White_Knight < Piece
    attr_reader :color, :symbol
    def initialize
        @color = "white"
        @symbol = ("\u2658")
    end
end
class White_Queen < Piece
    attr_reader :color, :symbol
    def initialize
        @color = "white"
        @symbol = ("\u2655")
    end
end
class White_King < Piece
    attr_reader :color, :symbol
    def initialize
        @color = "white"
        @symbol = ("\u2654")
    end
end
class Black_Rook < Piece
    attr_reader :color, :symbol
    def initialize
        @color = "black"
        @symbol = ("\u265C")
    end
end
class Black_Pawn < Piece
    attr_reader :color, :symbol
    attr_accessor :first
    def initialize
        @color = "black"
        @symbol = ("\u265F")
        @first = true
    end
end
class Black_Bishop < Piece
    attr_reader :color, :symbol
    def initialize
        @color = "black"
        @symbol = ("\u265D")
    end
end
class Black_Knight < Piece
    attr_reader :color, :symbol
    def initialize
        @color = "black"
        @symbol = ("\u265E")
    end
end
class Black_Queen < Piece
    attr_reader :color, :symbol
    def initialize
        @color = "black"
        @symbol = ("\u265B")
    end
end
class Black_King < Piece
    attr_reader :color, :symbol
    def initialize
        @color = "black"
        @symbol = ("\u265A")
    end
end
