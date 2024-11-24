//SPDX-license-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import{Hnadler} from "./Handler.t.sol";

contract InvariantsTest is StdInvariant, Test  {
    DeployerDSC deployer;
    DSCEngine dsce;
    DecentralizedStableCoin dsc;
    HelperConfig config;
    address weth;
    address wbtc;
    Handler handler;

    function setUp() external {
        deployer = new DeployDSC();
        (dsc, dsce, config) = deployer.run();
        (,, weth, wbtc,)= config.activeNetworkConfig();
        handler = new Handler(dsce, dsc);
        targetContract(address(handler));
    }

   function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
    uint256 totalsupply = dsc.totalSupply();
    uint256 totalWethDeposited = IERC20(weth).balanceof(address(dsce));
    uint256 totalBtcDeposited = IERC20(wbtc).balanceOf(address(dsce));

    uint256 wethValue = dsce.getUsdValue(weth,totalWethDeposited);
    uint256 wbtcValue = dsce.getUsdValue(wbtc, totalBtcDeposited);

    console.log("weth value: ",wbtcValue);
    console.log("weth value: ", wbtcValue);
    console.log("total supply:", totalSupply);
    console.log("Times mint called: ", handler.timesMintIsCalled();)
  
    assert(wethValue + wbtcValue >= totalSupply);
   }

   function invariant_getttersShouldNotRevert() public view  {
    dsce.getliqudationBonus();
    dsce.getPrecision();
   }
}