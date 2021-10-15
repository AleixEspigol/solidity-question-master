//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "../interfaces/IGame.sol";
import "../libraries/KnightMove.sol";
import "../libraries/SystemTypes.sol";
import "../libraries/Randomizer.sol"; 
import "hardhat/console.sol";
contract ComplexGame is IGame {

    uint32 numPieces; //number of pieces of the game
    uint32 numTypePieces; //number of the diferent types of pieces
    string[numPieces] public pieces; //array to safe all the diferent pieces
    SystemTypes.Position[] private positions; //currently positions of the pieces
    SystemTypes.Diff[] private bishopMoves; //moves that the bishop piece can do
    SystemTypes.Diff[] private queenMoves; //moves that the queen piece can do

    // @notice constructor to init all the variables
    // @params _numPieces number of pieces of the game
    // @params _pieces array to safe all the diferent pieces
    // @params _numTypePieces number of the diferent types of pieces
    constructor(uint32 _numPieces, string[] _pieces, uint32 _numTypePieces) {
        numPieces = _numPieces;
        numTypePieces = _numTypePieces;
        pieces[numPieces] = _pieces;

        bishopMoves =
            [
                SystemTypes.Diff(1,1),
                SystemTypes.Diff(1,-1),
                SystemTypes.Diff(-1,1),
                SystemTypes.Diff(-1,-1)
            ];
        queenMoves =
            [
                SystemTypes.Diff(1,1),
                SystemTypes.Diff(1,-1),
                SystemTypes.Diff(-1,1),
                SystemTypes.Diff(-1,-1),
                SystemTypes.Diff(1,0),
                SystemTypes.Diff(-1,0),
                SystemTypes.Diff(0,1),
                SystemTypes.Diff(0,-1)
            ];
        
        for(uint16 i = 0; i < queenMoves.length; i++){
            for(uint8 counter = 2; counter < 8; count++){
                SystemTypes.Diff memory newMove = queenMoves[i]*count;
                queenMoves.push(newMove);
            }
        }
         for(uint16 i = 0; i < bishopMoves.length; i++){
            for(uint8 counter = 2; counter < 8; count++){
                SystemTypes.Diff memory newMove = bishopMoves[i]*count;
                bishopMoves.push(newMove);
            }
        }
    }

    function play(uint256 _moves) override external { 
        for(uint i = 0; i < _moves; i++){
            uint randomPiece = Randomizer.random(pieces.length) % pieces.length;
            if (randomPiece == 'knight'){
                KnightMove knight = new KnightMove();
                SystemTypes.Position memory currentPosition = positions[randomPiece]; 
                console.log("Knight: My Position is (%d,%d)", currentPosition.X, currentPosition.Y);
                SystemTypes.Position[] memory possibles = knight.validMovesFor(currentPosition);
            } else {
                SystemTypes.Position memory currentPosition = positions[randomPiece]; 
                console.log(randomPiece, ": My Position is (%d,%d)", currentPosition.X, currentPosition.Y);
                SystemTypes.Position[] memory possibles = validMoves(currentPosition, randomPiece);
            }
            uint r = Randomizer.random(possibles.length) % possibles.length;
            if(checkPosition(possibles[r], positions) != true){
                r = Randomizer.random(possibles.length) % possibles.length;
            }
            currentPosition = possibles[r]; 
            console.log("%d: My Position is (%d,%d)", i, currentPosition.X, currentPosition.Y);
        } 
    }
    
    // @notice function that randomly places all the pieces initially
    function setup() override external {
        for(uint i = 0; i < numPieces; i++){
            uint x = Randomizer.random(8) % 8; 
            uint y = Randomizer.random(8) % 8; 
            if(checkPosition(SystemTypes.Position(x,y),positions) != true){
                x = Randomizer.random(8) % 8;
                y = Randomizer.random(8) % 8; 
            }
            positions[i] = SystemTypes.Position(x,y);
        }
    }

    // @notice function that checks the correct position of a piece
    // @params _positionToCheck position that we want to check
    // @params _positions positions of the other pieces
    function checkPosition(SystemTypes.Position _positionToCheck, SystemTypes.Position[] _positions) internal returns(bool) {
        bool correctPosition = true;
        for(uint i = 0; i < _positions.length; i++){
            if(_positionToCheck == _positions[i]){
                correctPosition = false;
            }
        }
        return correctPosition;
    }

    // @notice function that validates the possible movements that each piece can make
    // @params _position position that we want to valided
    // @params _typePiece type of piece that we want to valided
    function validMoves(SystemTypes.Position memory _position, string _typePiece) public view returns (SystemTypes.Position[] memory) {
        if(_typePiece == 'queen'){
            uint count = 0;
            for (uint i=0; i< queenMoves.length; i++) {
                int newX = int(_position.X) + queenMoves[i].X;
                int newY = int(_position.Y) + queenMoves[i].Y;
                if (newX > 8 || newX < 1 || newY > 8 || newY < 1){
                    continue;
                }
                count++; 
            }
            SystemTypes.Position[] memory results = new SystemTypes.Position[](count);
            uint index = 0;
            for (uint i=0; i < queenMoves.length; i++) {
                int newX = int(_position.X) + queenMoves[i].X;
                int newY = int(_position.Y) + queenMoves[i].Y;
                if (newX > 8 || newX < 1 || newY > 8 || newY < 1){
                    continue;
                }
            results[index] = SystemTypes.Position(uint(newX), uint(newY));
            index++;
            }  
        } else {
            uint count = 0;
            for (uint i=0; i< bishopMoves.length; i++) {
                int newX = int(_position.X) + bishopMoves[i].X;
                int newY = int(_position.Y) + bishopMoves[i].Y;
                if (newX > 8 || newX < 1 || newY > 8 || newY < 1){
                    continue;
                }
                count++; 
            }
            SystemTypes.Position[] memory results = new SystemTypes.Position[](count);
            uint index = 0;
            for (uint i=0; i < bishopMoves.length; i++) {
                int newX = int(_position.X) + bishopMoves[i].X;
                int newY = int(_position.Y) + bishopMoves[i].Y;
                if (newX > 8 || newX < 1 || newY > 8 || newY < 1){
                    continue;
                }
            results[index] = SystemTypes.Position(uint(newX), uint(newY));
            index++;
            }
        }
        return results;
    }
} 