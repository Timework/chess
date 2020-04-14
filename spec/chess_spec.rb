require './lib/chess'
require './lib/pieces'

RSpec.describe Chess do

    before (:each) do
        @game = Chess.new
        @game.make_board
    end

describe "#white_pawn_move" do
xit "Can properly move" do
piece = @game.board[6][7]
@game.white_pawn_move(6, 7, piece)
@game.show_board
answer = @game.board[4][7].is_a? Piece
expect(answer).to eql(TRUE)
end

xit "Can properly eat a black piece" do
piece = @game.board[6][7]
@game.board[5][6] = Black_Rook.new
@game.white_pawn_move(6, 7, piece)
@game.show_board
answer = @game.board[5][6].is_a? White_Pawn
expect(answer).to eql(TRUE)
end

xit "Can't jump over pieces" do
piece = @game.board[6][7]
@game.board[5][7] = White_Rook.new
@game.white_pawn_move(6, 7, piece)
@game.show_board
answer = @game.board[4][7].is_a? White_Pawn
expect(answer).to eql(FALSE)
end
end

describe "#black_pawn_move" do
xit "Can properly move" do
piece = @game.board[1][7]
@game.board[2][6] = Black_Rook.new
@game.black_pawn_move(1, 7, piece)
@game.show_board
answer = @game.board[3][7].is_a? Piece
expect(answer).to eql(TRUE)
end

xit "Can properly eat a white piece" do
piece = @game.board[1][7]
@game.board[2][6] = White_Rook.new
@game.black_pawn_move(1, 7, piece)
@game.show_board
answer = @game.board[2][6].is_a? Black_Pawn
expect(answer).to eql(TRUE)
end

xit "Can't jump over pieces" do
piece = @game.board[1][7]
@game.board[2][7] = White_Rook.new
@game.show_board
@game.black_pawn_move(1, 7, piece)
@game.show_board
answer = @game.board[1][7].is_a? Black_Pawn
expect(answer).to eql(TRUE)
end
end

describe "#black_knight_move" do
xit "Can move properly" do
    piece = @game.board[0][1]
    @game.show_board
    @game.black_knight_move(0, 1, piece)
    @game.show_board
    answer = @game.board[2][2].is_a? Black_Knight
    expect(answer).to eql(TRUE)
end

xit "Can eat white piece properly" do
    piece = @game.board[0][1]
    @game.board[2][2] = White_Rook.new
    @game.show_board
    @game.black_knight_move(0, 1, piece)
    @game.show_board
    answer = @game.board[2][2].is_a? Black_Knight
    expect(answer).to eql(TRUE)
end
end

describe "#white_knight_move" do
xit "Can move properly" do
    piece = @game.board[7][6]
    @game.show_board
    @game.white_knight_move(7, 6, piece)
    @game.show_board
    answer = @game.board[5][7].is_a? White_Knight
    expect(answer).to eql(TRUE)
end

xit "Can eat black piece properly" do
    @game.board[3][4] = White_Knight.new
    piece = @game.board[3][4]
    @game.show_board
    @game.white_knight_move(3, 4, piece)
    @game.show_board
    answer = @game.board[1][3].is_a? White_Knight
    expect(answer).to eql(TRUE)
end
end

describe "#black_rook_move" do
xit "No available moves works" do
    piece = @game.board[0][7]
    @game.show_board
    @game.black_rook_move(0, 7, piece)
    @game.show_board
    answer = @game.board[0][7].is_a? Black_Rook
    expect(answer).to eql(TRUE)
end

xit "can move right places" do
    @game.board[3][4] = Black_Rook.new
    piece = @game.board[3][4]
    @game.show_board
    @game.black_rook_move(3, 4, piece)
    @game.show_board
    answer = @game.board[6][4].is_a? Black_Rook
    expect(answer).to eql(TRUE)
end

xit "it can only move where it is suppose to" do
    @game.board[2][4] = Black_Pawn.new
    @game.board[3][5] = Black_Pawn.new
    @game.board[4][4] = Black_Pawn.new
    @game.board[3][2] = White_Pawn.new
    @game.board[3][4] = Black_Rook.new
    piece = @game.board[3][4]
    @game.show_board
    @game.black_rook_move(3, 4, piece)
    @game.show_board
    answer = @game.board[3][2].is_a? Black_Rook
    expect(answer).to eql(TRUE)
end
end

describe "#white_rook_move" do

xit "No available moves works" do
    piece = @game.board[7][7]
    @game.show_board
    @game.white_rook_move(7, 7, piece)
    @game.show_board
    answer = @game.board[7][7].is_a? White_Rook
    expect(answer).to eql(TRUE)
end

xit "it can only move where it is suppose to" do
    @game.board[2][4] = White_Pawn.new
    @game.board[3][5] = White_Pawn.new
    @game.board[4][4] = White_Pawn.new
    @game.board[3][2] = Black_Pawn.new
    @game.board[3][4] = White_Rook.new
    piece = @game.board[3][4]
    @game.show_board
    @game.white_rook_move(3, 4, piece)
    @game.show_board
    answer = @game.board[3][2].is_a? White_Rook
    expect(answer).to eql(TRUE)
end
end

describe "#black_bishop_move" do

xit "No available moves works" do
    piece = @game.board[0][5]
    @game.show_board
    @game.black_bishop_move(0, 5, piece)
    @game.show_board
    answer = @game.board[0][5].is_a? Black_Bishop
    expect(answer).to eql(TRUE)
end

xit "it can move properly" do
    @game.board[4][4] = Black_Bishop.new
    piece = @game.board[4][4]
    @game.show_board
    @game.black_bishop_move(4, 4, piece)
    @game.show_board
    answer = @game.board[6][6].is_a? Black_Bishop
    expect(answer).to eql(TRUE)
end
end

describe "#white_bishop_move" do
xit "No available moves works" do
    piece = @game.board[7][5]
    @game.show_board
    @game.white_bishop_move(7, 5, piece)
    @game.show_board
    answer = @game.board[7][5].is_a? White_Bishop
    expect(answer).to eql(TRUE)
end

xit "it can move properly" do
    @game.board[4][4] = White_Bishop.new
    piece = @game.board[4][4]
    @game.show_board
    @game.white_bishop_move(4, 4, piece)
    @game.show_board
    answer = @game.board[1][1].is_a? White_Bishop
    expect(answer).to eql(TRUE)
end
end

describe "#black_queen_move" do
xit "No available move works" do
    piece = @game.board[0][3]
    @game.show_board
    @game.black_queen_move(0, 3, piece)
    @game.show_board
    answer = @game.board[0][3].is_a? Black_Queen
    expect(answer).to eql(TRUE)
end

xit "it can move properly" do
    @game.board[4][3] = Black_Queen.new
    piece = @game.board[4][3]
    @game.show_board
    @game.black_queen_move(4, 3, piece)
    @game.show_board
    answer = @game.board[6][5].is_a? Black_Queen
    expect(answer).to eql(TRUE)
end

end

describe "#black_queen_move" do
xit "No available move works" do
    piece = @game.board[7][3]
    @game.show_board
    @game.white_queen_move(7, 3, piece)
    @game.show_board
    answer = @game.board[7][3].is_a? White_Queen
    expect(answer).to eql(TRUE)
end

xit "it can move properly" do
    @game.board[4][3] = White_Queen.new
    piece = @game.board[4][3]
    @game.show_board
    @game.white_queen_move(4, 3, piece)
    @game.show_board
    answer = @game.board[1][6].is_a? White_Queen
    expect(answer).to eql(TRUE)
end

end

describe "#black_king_move" do
xit "No available move works" do
    piece = @game.board[0][4]
    @game.show_board
    @game.black_king_move(0, 4, piece)
    @game.show_board
    answer = @game.board[0][4].is_a? Black_King
    expect(answer).to eql(TRUE)
end

xit "can move properly" do
    @game.board[5][3] = Black_King.new
    @game.board[4][3] = Black_Pawn.new
    piece = @game.board[5][3]
    @game.show_board
    @game.black_king_move(5, 3, piece)
    @game.show_board
    answer = @game.board[6][3].is_a? Black_King
    expect(answer).to eql(TRUE)
end
end

describe "#white_king_move" do
xit "No available move works" do
    piece = @game.board[7][4]
    @game.show_board
    @game.white_king_move(7, 4, piece)
    @game.show_board
    answer = @game.board[7][4].is_a? White_King
    expect(answer).to eql(TRUE)
end

xit "can move properly" do
    @game.board[2][3] = White_King.new
    @game.board[3][3] = White_Pawn.new
    piece = @game.board[2][3]
    @game.show_board
    @game.white_king_move(2, 3, piece)
    @game.show_board
    answer = @game.board[1][3].is_a? White_King
    expect(answer).to eql(TRUE)
end
end
end