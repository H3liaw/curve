import { BigNumber } from "ethers";
import { ethers } from "hardhat";
import { mainnet } from "./helper";



async function main() {
  const [deployer] = await ethers.getSigners();
  const {CurveWrapperV3}=mainnet;


  const Aggr = await ethers.getContractAt("CurveWrapperV3", CurveWrapperV3);


  Aggr.connect(deployer)
    .sell(
        "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174",
        "0x60D55F02A771d515e077c9C2403a1ef324885CeC",
        1000,
        "0x8dFf5E27EA6b7AC08EbFdf9eB090F32ee9a30fcf",
        "0x9d1af7EC1DC4486768E6c9e113fA412bA70DF7Cd",

      {
        gasLimit: 210000
      }
    )
    .then((data) => {
      console.log(data);
    });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
