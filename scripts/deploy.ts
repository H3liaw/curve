import { ethers } from "hardhat";

async function main() {

  const Agg = await ethers.getContractFactory("CurveWrapperV3");

  const contract = await Agg.deploy();

  await contract.deployed();

  console.log("CurveWrapperV3 contract: ", contract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
