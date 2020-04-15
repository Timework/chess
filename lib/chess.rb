require_relative "pieces"
require "yaml"

class Chess
    attr_accessor :board
    attr_reader :check_black, :check_white, :checkmate
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
        @king_black = [0, 4]
        @king_white = [7, 4]
        @turn = "white"
        @checkmate = false
        @check_white = false
        @check_black = false
    end

    def save
        game = YAML::dump(self)
        File.open("save_game.txt", "w").puts game
        puts "Game Saved"
        exit
    end

    def open_question
        puts "Type 1 for a new game or type 2 to load a game."
        @resultz = gets.chomp
        if @resultz != "1" && @resultz != "2"
            open_question
        end
    end
    
    def question
        puts "press 1 to play or 2 to save"
        @result = gets.chomp
        if @result != "1" && @result != "2"
            question
        end
    end

    def startup
        open_question
        if @resultz == "1"
            play
        else
            load_game
        end
    end

        def load_game
        game = File.read("save_game.txt")
        game = YAML::load(game)
        @current = game
        @current.play
    end

    def play
        while !@checkmate
            question
            if @result == "1"
            if @turn == "white"
                white_block
            else
                black_block
            end
        else
            save
        end
        end
        show_board
    end
    
    def white_block
        puts "white's turn"
        boardholder = Marshal.load(Marshal.dump(@board))
        choose_white
        white_pawn_check
        is_check_white?
        if @check_white
            puts "You cannot be in check"
            @board = Marshal.load(Marshal.dump(boardholder))
            white_block
        else
            @turn = "black"
        end
        is_check_black?
        if @check_black
            puts "check"
            king_escape_black
        end

    end

    def black_block
        puts "black's turn"
        boardholder = Marshal.load(Marshal.dump(@board))
        choose_black
        black_pawn_check
        is_check_black?
        if @check_black
            puts "You cannot be in check"
            @board = Marshal.load(Marshal.dump(boardholder))
            black_block
        else
            @turn = "white"
        end
        is_check_white?
        if @check_white
            puts "check"
            king_escape_white
        end
    end

    def king_escape_white
        @escapes = 0
        @board.each_with_index do |x, index_x|
            x.each_with_index do |y, index_y|
                if y.is_a? Piece
                    if y.color == "black"
                        if y.is_a? White_Pawn
                            white_pawn_escape(index_x, index_y, y)
                        elsif y.is_a? White_Rook
                            rook_escape(index_x, index_y, "black")
                        elsif y.is_a? White_Bishop
                            bishop_escape(index_x, index_y, "black")
                        elsif y.is_a? White_Knight
                            knight_escape(index_x, index_y, "black")
                        elsif y.is_a? White_Queen
                            queen_escape(index_x, index_y, "black")
                        elsif y.is_a? White_King
                            king_escape(index_x, index_y, "black")
                        end
                    end
                end
            end
        end
        if @escapes == 0
            puts "black won"
            @checkmate = true
        end
    end

    def white_pawn_escape(vert, hori, pawn)
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
            return
        else
            optional.each do |x|
                tempboard = Marshal.load(Marshal.dump(@board))
                tempboard[x[0]][x[1]] = piece
                tempboard[vert][hori] = " "
                is_check_white?
                if !@check_white
                    @escapes += 1
                end
            end
        end
    end

    def king_escape_black
        @escapes = 0
        @board.each_with_index do |x, index_x|
            x.each_with_index do |y, index_y|
                if y.is_a? Piece
                    if y.color == "black"
                        if y.is_a? Black_Pawn
                            black_pawn_escape(index_x, index_y, y)
                        elsif y.is_a? Black_Rook
                            rook_escape(index_x, index_y, "white")
                        elsif y.is_a? Black_Bishop
                            bishop_escape(index_x, index_y, "white")
                        elsif y.is_a? Black_Knight
                            knight_escape(index_x, index_y, "white")
                        elsif y.is_a? Black_Queen
                            queen_escape(index_x, index_y, "white")
                        elsif y.is_a? Black_King
                            king_escape(index_x, index_y, "white")
                        end
                    end
                end
            end
        end
        if @escapes == 0
            puts "white won"
            @checkmate = true
        end
    end

    def king_escape(vert, hori, color)
        piece = @board[vert][hori]
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
                    if @board[x[0]][x[1]].color == color
                        optional.push(x)
                    end
                end
            end
        end
        if optional.length == 0
            return 
        else
            optional.each do |x|
            tempboard = Marshal.load(Marshal.dump(@board))
            tempboard[x[0]][x[1]] = piece
            tempboard[vert][hori] = " "
            if color == "white"
            is_check_black?
            if !@check_black
                @escapes += 1
            end
        else
            is_check_white?
            if !@check_white
                @escapes += 1
            end
        end
    end
    end
    end

    def queen_escape(vert, hori, color)
        piece = @board[vert][hori]
        @optional = []
        bishop_up_left_move(vert - 1, hori - 1, color)
        bishop_up_right_move(vert - 1, hori + 1, color)
        bishop_down_right_move(vert + 1, hori + 1, color)
        bishop_down_left_move(vert + 1, hori - 1, color)
        rook_down_move(vert + 1, hori, color)
        rook_up_move(vert - 1, hori, color)
        rook_left_move(vert, hori - 1, color)
        rook_right_move(vert, hori + 1, color)
        if @optional.length == 0
            return
        else
        @optional.each do |x|
        tempboard = Marshal.load(Marshal.dump(@board))
            tempboard[x[0]][x[1]] = piece
            tempboard[vert][hori] = " "
            if color == "white"
            is_check_black?
            if !@check_black
                @escapes += 1
            end
        else
            is_check_white?
            if !@check_white
                @escapes += 1
            end
        end
        end
        end
    end

    def knight_escape(vert, hori, color)
        piece = @board[vert][hori]
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
                    if @board[x[0]][x[1]].color == color
                        optional.push(x)
                    end
                end
            end
        end
        if optional.length == 0
            return 
        else
            optional.each do |x|
            tempboard = Marshal.load(Marshal.dump(@board))
            tempboard[x[0]][x[1]] = piece
            tempboard[vert][hori] = " "
            if color == "white"
            is_check_black?
            if !@check_black
                @escapes += 1
            end
        else
            is_check_white?
            if !@check_white
                @escapes += 1
            end
        end
        end
        end
    end

    def bishop_escape(vert, hori, color)
        piece = @board[vert][hori]
        @optional = []
        bishop_up_left_move(vert - 1, hori - 1, color)
        bishop_up_right_move(vert - 1, hori + 1, color)
        bishop_down_right_move(vert + 1, hori + 1, color)
        bishop_down_left_move(vert + 1, hori - 1, color)
        if @optional.length == 0
            return
        else
        @optional.each do |x|
        tempboard = Marshal.load(Marshal.dump(@board))
            tempboard[x[0]][x[1]] = piece
            tempboard[vert][hori] = " "
            if color == "white"
            is_check_black?
            if !@check_black
                @escapes += 1
            end
        else
            is_check_white?
            if !@check_white
                @escapes += 1
            end
        end
        end
        end
    end

    def rook_escape(vert, hori, color)
        @rook_moves = []
        rook_down_move_escape(vert + 1, hori, color)
        rook_up_move_escape(vert - 1, hori, color)
        rook_left_move_escape(vert, hori - 1, color)
        rook_right_move_escape(vert, hori + 1, color)
        if @rook_moves.length == 0
            return
        else
            piece = @board[vert][hori]
            @rook_moves.each do |x|
                tempboard = Marshal.load(Marshal.dump(@board))
                tempboard[x[0]][x[1]] = piece
                tempboard[vert][hori] = " "
                if color == "white"
            is_check_black?
            if !@check_black
                @escapes += 1
            end
        else
            is_check_white?
            if !@check_white
                @escapes += 1
            end
        end
            end
        end
    end

    def rook_down_move_escape(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @rook_moves.push([vert, hori])
                rook_down_move_escape(vert + 1, hori, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @rook_moves.push([vert, hori])
                end
            end
        end
    end

    def rook_up_move_escape(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @rook_moves.push([vert, hori])
                rook_up_move_escape(vert - 1, hori, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @rook_moves.push([vert, hori])
                end
            end
        end
    end

    def rook_left_move_escape(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @rook_moves.push([vert, hori])
                rook_left_move_escape(vert, hori - 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @rook_moves.push([vert, hori])
                end
            end
        end
    end

    def rook_right_move_escape(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @rook_moves.push([vert, hori])
                rook_right_move_escape(vert, hori + 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @rook_moves.push([vert, hori])
                end
            end
        end
    end

    def black_pawn_escape(vert, hori, piece)
        optional = []
        if vert + 1 <= 7
            if @board[vert + 1][hori] == " "
                optional.push([vert+1, hori])
                if vert + 2 <= 7 && piece.first
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
            return
        else
            optional.each do |x|
                tempboard = Marshal.load(Marshal.dump(@board))
                tempboard[x[0]][x[1]] = piece
                tempboard[vert][hori] = " "
                is_check_black?
                if !@check_black
                    @escapes += 1
                end
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
            puts "no moves"
            return choose_white
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
            puts "no moves"
            return choose_black
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
            return choose_black
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
            return choose_white
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
            return choose_black
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
            return choose_white
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
            return choose_black
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
            return choose_white
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
            return choose_black
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
            return choose_white
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
            return choose_black
        end
        ask_move(optional)
        @board[@vert][@hori] = piece
        @king_black = [@vert, @hori]
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
            return choose_white
        end
        ask_move(optional)
        @board[@vert][@hori] = piece
        @king_white = [@vert, @hori]
        @board[vert][hori] = " "
    end
    
    def black_pawn_check
        @board[7].each_with_index do |x, y|
            if x.is_a? Black_Pawn
                @board[7][y] = transform_black
            end
        end
    end

    def transform_black
        puts "Transform your pawn"
        puts "Press 1 to make a rook, 2 for a bishop, 3 for a knight, 4 for a queen"
        tran = gets.chomp
        case tran
        when "1"
            return Black_Rook.new
        when "2"
            return Black_Bishop.new
        when "3"
            return Black_Knight.new
        when "4"
            return Black_Queen.new
        else
            puts "Please choose a number 1-4"
            return transform_black
        end
    end

    def white_pawn_check
        @board[0].each_with_index do |x, y|
            if x.is_a? White_Pawn
                @board[0][y] = transform_white
            end
        end
    end

    def transform_white
        puts "Transform your pawn"
        puts "Press 1 to make a rook, 2 for a bishop, 3 for a knight, 4 for a queen"
        tran = gets.chomp
        case tran
        when "1"
            return White_Rook.new
        when "2"
            return White_Bishop.new
        when "3"
            return White_Knight.new
        when "4"
            return White_Queen.new
        else
            puts "Please choose a number 1-4"
            return transform_white
        end
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

    def choose_white
        show_board
        puts "choose a piece"
        puts "choose vertical coordinate"
        verts = gets.chomp
        vert = verts.to_i
        puts "choose horizontal coordinate"
        horis = gets.chomp
        hori = horis.to_i
        if @includer.include? ([vert, hori])
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == "white"
                    piece = @board[vert][hori]
                    if @board[vert][hori].is_a? White_Pawn
                        white_pawn_move(vert, hori, piece)
                        return
                    elsif @board[vert][hori].is_a? White_Bishop
                        white_bishop_move(vert, hori, piece)
                        return
                    elsif @board[vert][hori].is_a? White_Rook
                        white_rook_move(vert, hori, piece)
                        return
                    elsif @board[vert][hori].is_a? White_Knight
                        white_knight_move(vert, hori, piece)
                        return
                    elsif @board[vert][hori].is_a? White_Queen
                        white_queen_move(vert, hori, piece)
                        return
                    elsif @board[vert][hori].is_a? White_King
                        white_king_move(vert, hori, piece)
                        return
                    end
                end
            end
        end
        puts "That is not a valid piece"
        return choose_white
    end

    def choose_black
        show_board
        puts "choose a piece"
        puts "choose vertical coordinate"
        verts = gets.chomp
        vert = verts.to_i
        puts "choose horizontal coordinate"
        horis = gets.chomp
        hori = horis.to_i
        if @includer.include? ([vert, hori])
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == "black"
                    piece = @board[vert][hori]
                    if @board[vert][hori].is_a? Black_Pawn
                        black_pawn_move(vert, hori, piece)
                        return
                    elsif @board[vert][hori].is_a? Black_Bishop
                        black_bishop_move(vert, hori, piece)
                        return
                    elsif @board[vert][hori].is_a? Black_Rook
                        black_rook_move(vert, hori, piece)
                        return
                    elsif @board[vert][hori].is_a? Black_Knight
                        black_knight_move(vert, hori, piece)
                        return
                    elsif @board[vert][hori].is_a? Black_Queen
                        black_queen_move(vert, hori, piece)
                        return
                    elsif @board[vert][hori].is_a? Black_King
                        black_king_move(vert, hori, piece)
                        return
                    end
                end
            end
        end
        puts "That is not a valid piece"
        return choose_black
    end

    def is_check_black?
        @all_options = []
        @board.each_with_index do |x, index_x|
            x.each_with_index do |y, index_y|
                if y.is_a? Piece
                    if y.color == "white"
                        if y.is_a? White_Pawn
                            all_pawn_white(index_x, index_y, y)
                        elsif y.is_a? White_Rook
                            all_rook(index_x, index_y, "black")
                        elsif y.is_a? White_Bishop
                            all_bishop(index_x, index_y, "black")
                        elsif y.is_a? White_Knight
                            all_knight(index_x, index_y, "black")
                        elsif y.is_a? White_Queen
                            all_queen(index_x, index_y, "black")
                        elsif y.is_a? White_King
                            all_king(index_x, index_y, "black")
                        end
                    end
                end
            end
        end
        if @all_options.include? (@king_black)
            @check_black = TRUE
        else
            @check_black = FALSE
        end
    end

    def all_pawn_white(vert, hori, pawn)
        if vert - 1 >= 0
            if @board[vert - 1][hori] == " "
                @all_options.push([vert-1, hori])
                if vert - 2 >= 0 && pawn.first
                     if @board[vert - 2][hori] == " "
                        @all_options.push([vert - 2, hori])
                     end
                 end
            end
        end
        if @board[vert - 1][hori + 1].is_a? Piece
            if @board[vert - 1][hori + 1].color == "black"
                @all_options.push([vert - 1, hori + 1])
            end
        end
        if @board[vert - 1][hori - 1].is_a? Piece
            if @board[vert - 1][hori - 1].color == "black"
                @all_options.push([vert - 1, hori - 1])
            end
        end
    end

    def all_knight(vert, hori, color)
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
                    @all_options.push(x)
                elsif @board[x[0]][x[1]].is_a? Piece
                    if @board[x[0]][x[1]].color == color
                        @all_options.push(x)
                    end
                end
            end
        end
    end

    def all_bishop(vert, hori, color)
        bishop_up_left_move_all(vert - 1, hori - 1, color)
        bishop_up_right_move_all(vert - 1, hori + 1, color)
        bishop_down_right_move_all(vert + 1, hori + 1, color)
        bishop_down_left_move_all(vert + 1, hori - 1, color)
    end

    def bishop_up_left_move_all(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @all_options.push([vert, hori])
                bishop_up_left_move_all(vert - 1, hori - 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @all_options.push([vert, hori])
                end
            end
        end
    end

    def bishop_up_right_move_all(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @all_options.push([vert, hori])
                bishop_up_right_move_all(vert - 1, hori + 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @all_options.push([vert, hori])
                end
            end
        end
    end

    def bishop_down_right_move_all(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @all_options.push([vert, hori])
                bishop_down_right_move_all(vert + 1, hori + 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @all_options.push([vert, hori])
                end
            end
        end
    end

    def bishop_down_left_move_all(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @all_options.push([vert, hori])
                bishop_down_left_move_all(vert + 1, hori - 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @all_options.push([vert, hori])
                end
            end
        end
    end

    def all_rook(vert, hori, color)
        rook_down_move_all(vert + 1, hori, color)
        rook_up_move_all(vert - 1, hori, color)
        rook_left_move_all(vert, hori - 1, color)
        rook_right_move_all(vert, hori + 1, color)
    end

    def rook_down_move_all(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @all_options.push([vert, hori])
                rook_down_move_all(vert + 1, hori, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @all_options.push([vert, hori])
                end
            end
        end
    end

    def rook_up_move_all(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @all_options.push([vert, hori])
                rook_up_move_all(vert - 1, hori, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @all_options.push([vert, hori])
                end
            end
        end
    end

    def rook_left_move_all(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @all_options.push([vert, hori])
                rook_left_move_all(vert, hori - 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @all_options.push([vert, hori])
                end
            end
        end
    end

    def rook_right_move_all(vert, hori, color)
        if @includer.include?([vert, hori])
            if @board[vert][hori] == " "
                @all_options.push([vert, hori])
                rook_right_move_all(vert, hori + 1, color)
            end
            if @board[vert][hori].is_a? Piece
                if @board[vert][hori].color == color
                    @all_options.push([vert, hori])
                end
            end
        end
    end

    def all_queen(vert, hori, color)
        rook_down_move_all(vert + 1, hori, color)
        rook_up_move_all(vert - 1, hori, color)
        rook_left_move_all(vert, hori - 1, color)
        rook_right_move_all(vert, hori + 1, color)
        bishop_up_left_move_all(vert - 1, hori - 1, color)
        bishop_up_right_move_all(vert - 1, hori + 1, color)
        bishop_down_right_move_all(vert + 1, hori + 1, color)
        bishop_down_left_move_all(vert + 1, hori - 1, color)
    end

    def all_king(vert, hori, color)
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
                    @all_options.push(x)
                elsif @board[x[0]][x[1]].is_a? Piece
                    if @board[x[0]][x[1]].color == color
                        @all_options.push(x)
                    end
                end
            end
        end
    end

    def is_check_white?
        @all_options = []
        @board.each_with_index do |x, index_x|
            x.each_with_index do |y, index_y|
                if y.is_a? Piece
                    if y.color == "black"
                        if y.is_a? Black_Pawn
                            all_pawn_black(index_x, index_y, y)
                        elsif y.is_a? Black_Rook
                            all_rook(index_x, index_y, "white")
                        elsif y.is_a? Black_Bishop
                            all_bishop(index_x, index_y, "white")
                        elsif y.is_a? Black_Knight
                            all_knight(index_x, index_y, "white")
                        elsif y.is_a? Black_Queen
                            all_queen(index_x, index_y, "white")
                        elsif y.is_a? Black_King
                            all_king(index_x, index_y, "white")
                        end
                    end
                end
            end
        end
        if @all_options.include? (@king_white)
            @check_white = TRUE
        else
            @check_white = FALSE
        end
    end

    def all_pawn_black(vert, hori, pawn)
        if vert + 1 <= 7
            if @board[vert + 1][hori] == " "
                @all_options.push([vert+1, hori])
                if vert + 2 <= 7 && pawn.first
                     if @board[vert + 2][hori] == " "
                            @all_options.push([vert + 2, hori])
                    end
                end
            end
        end
        if @board[vert + 1][hori + 1].is_a? Piece
            if @board[vert + 1][hori + 1].color == "white"
                @all_options.push([vert + 1, hori + 1])
            end
        end
        if @board[vert + 1][hori - 1].is_a? Piece
            if @board[vert + 1][hori - 1].color == "white"
                @all_options.push([vert + 1, hori - 1])
            end
        end
    end
end
