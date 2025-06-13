import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

// Compound Protocol Mainnet Addresses
const COMPOUND_ADDRESSES = {
  COMPTROLLER: "0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B",
  PRICE_FEED: "0x922018674c12a7F0D394ebEEf9B58F186CdE13c1",
  CETH: "0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5", // Compound's cETH token
  CWBTC: "0xC11b1268C1A384e55C48c2391d8d480264A3A7F4", // Compound's cWBTC token
  WBTC: "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599", // WBTC token
};

const MainnetKompoundModule = buildModule("MainnetKompoundModule", (m) => {
  // Deploy CompoundEth contract
  const compoundEth = m.contract("CompoundEth", [COMPOUND_ADDRESSES.CETH]);

  // Deploy CompoundErc20 contract
  const compoundErc20 = m.contract("CompoundErc20", [
    COMPOUND_ADDRESSES.WBTC,
    COMPOUND_ADDRESSES.CWBTC,
  ]);

  // Deploy CompoundLong contract
  const compoundLong = m.contract("CompoundLong", [
    COMPOUND_ADDRESSES.CETH,
    COMPOUND_ADDRESSES.CWBTC,
    COMPOUND_ADDRESSES.WBTC,
    8, // WBTC decimals
  ]);

  // Deploy CompoundLiquidate contract
  const compoundLiquidator = m.contract("CompoundLiquidator", [
    COMPOUND_ADDRESSES.WBTC,
    COMPOUND_ADDRESSES.CWBTC,
  ]);

  return {
    compoundEth,
    compoundErc20,
    compoundLong,
    compoundLiquidator,
  };
});

export default MainnetKompoundModule;
