//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./cores/SimpleGame.sol";
import "./cores/ComplexGame.sol";

contract GameRunner {

    function runSimple() external {
      SimpleGame game = new SimpleGame(); 
      game.setup();
      game.play(10);
    }
    
    // @notice function that run a complex game with a lot of pieces and typies
    // @params _numPieces amount of pieces of the game
    // @params _pieces array with all the pieces
    // @params _numTypePieces amount of the different type of pieces
    function runComplex(_numPieces, _pieces, _numTypePieces) external {
      ComplexGame game = new ComplexGame(_numPieces, _pieces, _numTypePieces);
      game.setup();
      game.play(10); 
    }
}
 
