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

it "Can't jump over pieces" do
piece = @game.board[1][7]
@game.board[2][7] = White_Rook.new
@game.show_board
@game.black_pawn_move(1, 7, piece)
@game.show_board
answer = @game.board[1][7].is_a? Black_Pawn
expect(answer).to eql(TRUE)
end
end
end