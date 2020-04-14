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
        @includer = []
        arr = (0..7).to_a
        arr.each do |x|
            arr.each do |y|
                @includer.push([x, y])
            end
        end
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

    def black_knight_move(vert, hori, piece)
        optional = []
        knights_move = [
                        [vert + 1, hori + 2],
                        [vert - 1, hori + 2],
                        [vert - 2, hori + 1],
                        [vert + 2, hori + 1],
                        [vert + 1, hori - 2],
                        [vert - 1, hori - 2],
                        [vert - 2, hori - 1],
                        [vert + 2, hori - 1]                                       
                    ]
        knights_move.each do |x|
            if @includer.include?(x)
                if @board[x[0]][x[1]] == " "
                    optional.push(x)
                elsif @board[x[0]][x[1]].is_a? Piece
                    if @board[x[0]][x[1]].color == "white"
                        optional.push(x)
                    end
                end
            end
        end
        if optional.length == 0
            puts "no moves"
            return "There are no available moves"
        end
        ask_move(optional)
        @board[@vert][@hori] = piece
        @board[vert][hori] = " "
    end

    def white_knight_move(vert, hori, piece)
        optional = []
        knights_move = [
                        [vert + 1, hori + 2],
                        [vert - 1, hori + 2],
                        [vert - 2, hori + 1],
                        [vert + 2, hori + 1],
                        [vert + 1, hori - 2],
                        [vert - 1, hori - 2],
                        [vert - 2, hori - 1],
                        [vert + 2, hori - 1]                                       
                    ]
        knights_move.each do |x|
            if @includer.include?(x)
                if @board[x[0]][x[1]] == " "
                    optional.push(x)
                elsif @board[x[0]][x[1]].is_a? Piece
                    if @board[x[0]][x[1]].color == "black"
                        optional.push(x)
                    end
                end
            end
        end
        if optional.length == 0
            puts "no moves"
            return "There are no available moves"
        end
        ask_move(optional)
        @board[@vert][@hori] = piece
        @board[vert][hori] = " "
    end

    def black_rook_move(vert, hori, piece)
        @optional = []
        rook_down_move(vert + 1, hori, "white")
        rook_up_move(vert - 1, hori, "white")
        rook_left_move(vert, hori - 1, "white")
        rook_right_move(vert, hori + 1, "white")
        if @optional.length == 0
            puts "no moves"
            return "There are no available moves"
        end
        ask_move(@optional)
        @board[@vert][@hori] = piece
        @board[vert][hori] = " "
    end

    def white_rook_move(vert, hori, piece)
        @optional = []
        rook_down_move(vert + 1, hori, "black")
        rook_up_move(vert - 1, hori, "black")
        rook_left_move(vert, hori - 1, "black")
        rook_right_move(vert, hori + 1, "black")
        if @optional.length == 0
            puts "no moves"
            return "There are no available moves"
        end
        ask_move(@optional)
        @board[@vert][@hori] = piece
        @board[vert][hori] = " "
    end

    def rook_down_move(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @optional.push([vert, hori])
                rook_down_move(vert + 1, hori, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @optional.push([vert, hori])
                end
            end
        end
    end

    def rook_up_move(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @optional.push([vert, hori])
                rook_up_move(vert - 1, hori, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @optional.push([vert, hori])
                end
            end
        end
    end

    def rook_left_move(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @optional.push([vert, hori])
                rook_left_move(vert, hori - 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @optional.push([vert, hori])
                end
            end
        end
    end

    def rook_right_move(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @optional.push([vert, hori])
                rook_right_move(vert, hori + 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @optional.push([vert, hori])
                end
            end
        end
    end

    def black_bishop_move(vert, hori, piece)
        @optional = []
        bishop_up_left_move(vert - 1, hori - 1, "white")
        bishop_up_right_move(vert - 1, hori + 1, "white")
        bishop_down_right_move(vert + 1, hori + 1, "white")
        bishop_down_left_move(vert + 1, hori - 1, "white")
        if @optional.length == 0
            puts "no moves"
            return "There are no available moves"
        end
        ask_move(@optional)
        @board[@vert][@hori] = piece
        @board[vert][hori] = " "
    end

    def white_bishop_move(vert, hori, piece)
        @optional = []
        bishop_up_left_move(vert - 1, hori - 1, "black")
        bishop_up_right_move(vert - 1, hori + 1, "black")
        bishop_down_right_move(vert + 1, hori + 1, "black")
        bishop_down_left_move(vert + 1, hori - 1, "black")
        if @optional.length == 0
            puts "no moves"
            return "There are no available moves"
        end
        ask_move(@optional)
        @board[@vert][@hori] = piece
        @board[vert][hori] = " "
    end

    def bishop_up_left_move(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @optional.push([vert, hori])
                bishop_up_left_move(vert - 1, hori - 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @optional.push([vert, hori])
                end
            end
        end
    end

    def bishop_up_right_move(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @optional.push([vert, hori])
                bishop_up_right_move(vert - 1, hori + 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @optional.push([vert, hori])
                end
            end
        end
    end

    def bishop_down_right_move(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @optional.push([vert, hori])
                bishop_down_right_move(vert + 1, hori + 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @optional.push([vert, hori])
                end
            end
        end
    end

    def bishop_down_left_move(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @optional.push([vert, hori])
                bishop_down_left_move(vert + 1, hori - 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @optional.push([vert, hori])
                end
            end
        end
    end

    def black_queen_move(vert, hori, piece)
        @optional = []
        bishop_up_left_move(vert - 1, hori - 1, "white")
        bishop_up_right_move(vert - 1, hori + 1, "white")
        bishop_down_right_move(vert + 1, hori + 1, "white")
        bishop_down_left_move(vert + 1, hori - 1, "white")
        rook_down_move(vert + 1, hori, "white")
        rook_up_move(vert - 1, hori, "white")
        rook_left_move(vert, hori - 1, "white")
        rook_right_move(vert, hori + 1, "white")
        if @optional.length == 0
            puts "no moves"
            return "There are no available moves"
        end
        ask_move(@optional)
        @board[@vert][@hori] = piece
        @board[vert][hori] = " "
    end

    def white_queen_move(vert, hori, piece)
        @optional = []
        bishop_up_left_move(vert - 1, hori - 1, "black")
        bishop_up_right_move(vert - 1, hori + 1, "black")
        bishop_down_right_move(vert + 1, hori + 1, "black")
        bishop_down_left_move(vert + 1, hori - 1, "black")
        rook_down_move(vert + 1, hori, "black")
        rook_up_move(vert - 1, hori, "black")
        rook_left_move(vert, hori - 1, "black")
        rook_right_move(vert, hori + 1, "black")
        if @optional.length == 0
            puts "no moves"
            return "There are no available moves"
        end
        ask_move(@optional)
        @board[@vert][@hori] = piece
        @board[vert][hori] = " "
    end

    def black_king_move(vert, hori, piece)
        optional = []
        kings_move = [
                        [vert + 1, hori],
                        [vert + 1, hori - 1],
                        [vert + 1, hori + 1],
                        [vert - 1, hori],
                        [vert - 1, hori - 1],
                        [vert - 1, hori + 1],
                        [vert, hori + 1],
                        [vert, hori - 1]                                       
                    ]
        kings_move.each do |x|
            if @includer.include?(x)
                if @board[x[0]][x[1]] == " "
                    optional.push(x)
                elsif @board[x[0]][x[1]].is_a? Piece
                    if @board[x[0]][x[1]].color == "white"
                        optional.push(x)
                    end
                end
            end
        end
        if optional.length == 0
            puts "no moves"
            return "There are no available moves"
        end
        ask_move(optional)
        @board[@vert][@hori] = piece
        @board[vert][hori] = " "
    end

    def white_king_move(vert, hori, piece)
        optional = []
        kings_move = [
                        [vert + 1, hori],
                        [vert + 1, hori - 1],
                        [vert + 1, hori + 1],
                        [vert - 1, hori],
                        [vert - 1, hori - 1],
                        [vert - 1, hori + 1],
                        [vert, hori + 1],
                        [vert, hori - 1]                                       
                    ]
        kings_move.each do |x|
            if @includer.include?(x)
                if @board[x[0]][x[1]] == " "
                    optional.push(x)
                elsif @board[x[0]][x[1]].is_a? Piece
                    if @board[x[0]][x[1]].color == "black"
                        optional.push(x)
                    end
                end
            end
        end
        if optional.length == 0
            puts "no moves"
            return "There are no available moves"
        end
        ask_move(optional)
        @board[@vert][@hori] = piece
        @board[vert][hori] = " "
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
