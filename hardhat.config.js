/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require("dotenv").config();
require("@nomiclabs/hardhat-ethers");
// const API_URL = process.env.API_URL;
// const PRIVATE_KEY = process.env.PRIVATE_KEY;
const { API_URL, PRIVATE_KEY, ETHERSCAN_API } = process.env;

module.exports = {
  solidity: "0.8.0",
  defaultNetwork: "goerli",
  networks: {
    hardhat: {},
    goerli: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API,
  },
};
