import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
// const conf = require("./secret");

dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
const privateKey =
  process.env.PRIVATE_KEY_1;
const privateKey2 =process.env.PRIVATE_KEY_2;

const config: HardhatUserConfig = {
  solidity: "0.8.10",
  defaultNetwork: "polygan",
  networks: {
    hardhat: {
      chainId: 137,
      forking: {
        url: "https://polygon-rpc.com",

      },
      accounts: [{ privateKey: `${privateKey}`, balance: "100000000000000000000000" }, { privateKey: `${privateKey2}`, balance: "100000000000000000000000" }]
    },
    polygan:{
      url: "https://polygon-rpc.com",
      chainId: 137,
      accounts: [`${privateKey}`, `${privateKey2}`],
    },
  },};

export default config;

