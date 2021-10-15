import { ethers } from "hardhat";

const numPieces = 3;
const numTypePieces = 3;
const pieces = ['knight','queen','bishop']; 
async function main() {
   run('compile');
   const SimpleGame = await ethers.getContractFactory('SimpleGame');
   const simpleGame = await SimpleGame.deploy();
   console.log('SimpleGame deployed to:', simpleGame.address);
   const ComplexGame = await ethers.getContractFactory('ComplexGame');
   const complexGame = await ComplexGame.deploy(numPieces, pieces, numTypePieces);
   console.log('ComplexGame deployed to:', complexGame.address);
}
 
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
