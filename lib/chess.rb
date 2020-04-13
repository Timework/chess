require_relative "pieces"

class Chess
    attr_accessor :board
    def make_board
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
        4.times do
            @board.push([" "," "," "," "," "," "," "," "])
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
        counter = 0
        @show_board.each do |x|
            print "#{counter} | " + x.join(" | ") + " |"
            puts
            print ("  ")
            33.times do
                print ("\u2015")
            end
            counter += 1
            puts
        end
        print "    0   1   2   3   4   5   6   7"
        puts
    end

    def white_pawn_move(vert, hori, pawn)
        optional = []
        if vert - 1 >= 0
            if @board[vert - 1][hori] == " "
                optional.push([vert-1, hori])
                if vert - 2 >= 0 && pawn.first
                     if @board[vert - 2][hori] == " "
                        optional.push([vert - 2, hori])
                     end
                 end
            end
        end
        if @board[vert - 1][hori + 1].is_a? Piece
            if @board[vert - 1][hori + 1].color == "black"
                optional.push([vert - 1, hori + 1])
            end
        end
        if @board[vert - 1][hori - 1].is_a? Piece
            if @board[vert - 1][hori - 1].color == "black"
                optional.push([vert - 1, hori - 1])
            end
        end
        if optional.length == 0
            return "There are no available moves"
        end
        num = ask_move(optional)
        @board[@vert][@hori] = pawn
        @board[vert][hori] = " "
        pawn.first = false
    end

    def black_pawn_move(vert, hori, pawn)
        optional = []
        if vert + 1 <= 7
            if @board[vert + 1][hori] == " "
                optional.push([vert+1, hori])
                if vert + 2 <= 7 && pawn.first
                     if @board[vert + 2][hori] == " "
                            optional.push([vert + 2, hori])
                    end
                end
            end
        end
        if @board[vert + 1][hori + 1].is_a? Piece
            if @board[vert + 1][hori + 1].color == "white"
                optional.push([vert + 1, hori + 1])
            end
        end
        if @board[vert + 1][hori - 1].is_a? Piece
            if @board[vert + 1][hori - 1].color == "white"
                optional.push([vert + 1, hori - 1])
            end
        end
        if optional.length == 0
            return "There are no available moves"
        end
        num = ask_move(optional)
        @board[@vert][@hori] = pawn
        @board[vert][hori] = " "
        pawn.first = false
    end

    def ask_move(optional)
        puts "optional moves"
        print optional
        puts
        puts "Pick your vertical number for movement"
        vert = gets.chomp
        puts "Pick your horizontal number for movement"
        hori = gets.chomp
        verts = vert.to_i
        horis = hori.to_i
        if optional.include? ([verts, horis])
            @vert = verts
            @hori = horis
        else
            puts "That is not an optional move, choose again"
            ask_move(optional)
        end
    end
end
