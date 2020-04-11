require_relative "pieces"

class Chess
    def board
        @board = []
        blackline = []
        blackline.push(Black_Rook.new)
        blackline.push(Black_Knight.new)
        blackline.push(Black_Bishop.new)
        blackline.push(Black_Queen.new)
        blackline.push(Black_King.new)
        blackline.push(Black_Bishop.new)
        blackline.push(Black_Knight.new)
        blackline.push(Black_Rook.new)
        @board.push(blackline)
        temp = []
        8.times do
            temp.push(Black_Pawn.new)
        end
        @board.push(temp)
        blank = []
        8.times do
            blank.push(" ")
        end
        4.times do
            @board.push(blank)
        end
        pawns = []
        8.times do
            pawns.push(White_Pawn.new)
        end
        @board.push(pawns)
        whiteline = []
        whiteline.push(White_Rook.new)
        whiteline.push(White_Knight.new)
        whiteline.push(White_Bishop.new)
        whiteline.push(White_Queen.new)
        whiteline.push(White_King.new)
        whiteline.push(White_Bishop.new)
        whiteline.push(White_Knight.new)
        whiteline.push(White_Rook.new)
        @board.push(whiteline)
    end

    def show_board
        @show_board = []
        @board.each do |y|
            holder = []
            y.each do |x|
                if x.is_a? Piece
                    holder.push(x.symbol)
                else
                    holder.push(x)
                end
            end
            @show_board.push(holder)
        end
        @show_board.each do |x|
            print "| " + x.join(" | ") + " |"
            puts
            33.times do
                print ("\u2015")
            end
            puts
        end
    end
end
game = Chess.new
game.board
game.show_board