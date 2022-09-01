pragma solidity ^0.8.14;

import "./util/ERC20.sol";
import {MasterDeployer} from "../src/MasterDeployer.sol";
import "../src/ConcentratedLiquidityPool.sol";
import "../src/ConcentratedLiquidityPoolFactory.sol";
import "../src/interfaces/IPositionManager.sol";

contract SwappingTests is IPositionManager {

    MasterDeployer master_deployer;
    ConcentratedLiquidityPoolFactory pool_deployer;

    ERC20 tokenA;
    ERC20 tokenB;

    ConcentratedLiquidityPool test_pool;

    function setUp() public {
        master_deployer = new MasterDeployer(100, address(this));
        pool_deployer = new ConcentratedLiquidityPoolFactory(address(master_deployer));

        tokenA = new ERC20("TokenA", "A", 18);
        tokenB = new ERC20("TokenB", "B", 18);


        bytes memory deploy_data = abi.encode(address(tokenA), address(tokenB), 0, 5000000000, 15);

        test_pool = ConcentratedLiquidityPool(pool_deployer.deployPool(deploy_data));
    }
    function mintCallback(
        address token0,
        address token1,
        uint256 amount0,
        uint256 amount1,
        bool native
    ) external {
        ERC20(token0).transfer(msg.sender, amount0);
        ERC20(token1).transfer(msg.sender, amount1);
    }

    function test_addLiquidity() public {
        tokenA.mint(address(this), 1000 ether);
        tokenB.mint(address(this), 1 ether);

        IConcentratedLiquidityPoolStruct.MintParams memory params = IConcentratedLiquidityPoolStruct.MintParams({
            lowerOld: TickMath.MIN_TICK,
            lower: -30,
            upperOld: -30,
            upper: 105,
            amount0Desired: 1000 ether,
            amount1Desired: 1 ether,
            native: false
        });

        uint256 out = test_pool.mint(params);
        require(out > 0);
    }

    function test_removeLiquidity() public {

    }

    function test_swap() public {
        
    }
}
