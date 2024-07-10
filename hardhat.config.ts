import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";
import 'solidity-coverage';

dotenv.config();

const TEST_PRIVATE_KEY: string = process.env.TEST_PRIVATE_KEY ?? '';
const INFURA_API_KEY: string = process.env.INFURA_API_KEY ?? '';
const ETHER_SCAN_API_KEY: string = process.env.ETHER_SCAN_API_KEY ?? '';
const MAINNET_PRIVATE_KEY: string = process.env.MAINNET_PRIVATE_KEY ?? '';
const POLYGON_MUMBAI_PRIVATE_KEY: string = process.env.POLYGON_MUMBAI_PRIVATE_KEY ?? '';
const POLYGON_SCAN_API_KEY: string = process.env.POLYGON_SCAN_API_KEY ?? '';
const BACKEND_PRIVATE_KEY: string = process.env.BACKEND_PRIVATE_KEY ?? '';

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,        
      },      
    }
  },
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [TEST_PRIVATE_KEY, BACKEND_PRIVATE_KEY]
    },
    ethereum: {
      url: `https://mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [MAINNET_PRIVATE_KEY, BACKEND_PRIVATE_KEY]
    },
    polygon: {
      url: `https://polygon-mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [POLYGON_MUMBAI_PRIVATE_KEY, BACKEND_PRIVATE_KEY]
    },
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [TEST_PRIVATE_KEY, BACKEND_PRIVATE_KEY]
    },
    besu: {
      url: `http://besu.beruwa.la:8545`,
      accounts: [TEST_PRIVATE_KEY, BACKEND_PRIVATE_KEY]
    },
    localhost: {
      url: 'http://127.0.0.1:8545/'
    }
  },
  etherscan: {
    apiKey: POLYGON_SCAN_API_KEY,
  },
};

export default config;
