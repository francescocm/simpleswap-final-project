// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IERC20
 * @dev Minimal interface for ERC20 token functions required by the swap contract.
 */
interface IERC20 {
    function transfer(address recipient, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
}

/**
 * @title SimpleSwap
 * @author Francesco Centarti Maestu
 * @notice A basic Automated Market Maker (AMM) contract to add/remove liquidity
 * and swap tokens for a given pair. This contract does not charge any fees.
 */
contract SimpleSwap {

    // State Variables
    mapping(address => mapping(address => uint)) public reserves;
    mapping(address => mapping(address => mapping(address => uint))) public liquidity;

    // Events
    event LiquidityAdded(address indexed provider, address indexed tokenA, address indexed tokenB, uint amountA, uint amountB, uint liquidity);
    event LiquidityRemoved(address indexed provider, address indexed tokenA, address indexed tokenB, uint amountA, uint amountB, uint liquidity);
    event Swap(address indexed user, address indexed tokenIn, address indexed tokenOut, uint amountIn, uint amountOut);


    // Internal and View Functions
    function getReserves(address tokenA, address tokenB) public view returns (uint reserveA, uint reserveB) {
        reserveA = reserves[tokenA][tokenB];
        reserveB = reserves[tokenB][tokenA];
    }

    function getLiquidity(address tokenA, address tokenB, address user) internal view returns (uint) {
        return liquidity[tokenA][tokenB][user];
    }

    function setLiquidity(address tokenA, address tokenB, address user, uint amount) internal {
        liquidity[tokenA][tokenB][user] = amount;
    }


    // Core Functions
    
    /**
     * @notice Adds liquidity to a token pair pool.
     * @dev Solves "Stack too deep" by using a local scope for calculations.
     */
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidityMinted) {
        require(block.timestamp <= deadline, "EXPIRED");

        // --- Start of local scope to manage stack depth ---
        {
            (uint reserveA, uint reserveB) = getReserves(tokenA, tokenB);

            if (reserveA == 0 && reserveB == 0) {
                amountA = amountADesired;
                amountB = amountBDesired;
            } else {
                uint amountBOptimal = (amountADesired * reserveB) / reserveA;
                if (amountBOptimal <= amountBDesired) {
                    require(amountBOptimal >= amountBMin, "LOW_B");
                    amountA = amountADesired;
                    amountB = amountBOptimal;
                } else {
                    uint amountAOptimal = (amountBDesired * reserveA) / reserveB;
                    require(amountAOptimal >= amountAMin, "LOW_A");
                    amountA = amountAOptimal;
                    amountB = amountBDesired;
                }
            }
        } // --- End of local scope. Variables inside are cleared from the stack. ---

        IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);

        liquidityMinted = amountA + amountB;

        uint currentLiquidity = getLiquidity(tokenA, tokenB, to);
        setLiquidity(tokenA, tokenB, to, currentLiquidity + liquidityMinted);

        reserves[tokenA][tokenB] += amountA;
        reserves[tokenB][tokenA] += amountB;

        emit LiquidityAdded(msg.sender, tokenA, tokenB, amountA, amountB, liquidityMinted);
    }

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidityAmount,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB) {
        require(block.timestamp <= deadline, "EXPIRED");

        uint userLiquidity = getLiquidity(tokenA, tokenB, msg.sender);
        require(userLiquidity >= liquidityAmount, "INSUFFICIENT_LIQUIDITY");

        (uint reserveA, uint reserveB) = getReserves(tokenA, tokenB);

        amountA = (liquidityAmount * reserveA) / userLiquidity;
        amountB = (liquidityAmount * reserveB) / userLiquidity;

        require(amountA >= amountAMin, "LOW_A_OUT");
        require(amountB >= amountBMin, "LOW_B_OUT");

        setLiquidity(tokenA, tokenB, msg.sender, userLiquidity - liquidityAmount);

        reserves[tokenA][tokenB] -= amountA;
        reserves[tokenB][tokenA] -= amountB;

        IERC20(tokenA).transfer(to, amountA);
        IERC20(tokenB).transfer(to, amountB);

        emit LiquidityRemoved(msg.sender, tokenA, tokenB, amountA, amountB, liquidityAmount);
    }
    
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts) {
        require(block.timestamp <= deadline, "EXPIRED");
        require(path.length == 2, "INVALID_PATH");

        address tokenIn = path[0];
        address tokenOut = path[1];

        (uint reserveIn, uint reserveOut) = getReserves(tokenIn, tokenOut);

        uint amountOut = getAmountOut(amountIn, reserveIn, reserveOut);
        require(amountOut >= amountOutMin, "INSUFFICIENT_OUTPUT");

        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        
        reserves[tokenIn][tokenOut] += amountIn;
        reserves[tokenOut][tokenIn] -= amountOut;

        IERC20(tokenOut).transfer(to, amountOut);

        emit Swap(msg.sender, tokenIn, tokenOut, amountIn, amountOut);
        
        amounts = new uint[](2);
        amounts[0] = amountIn;
        amounts[1] = amountOut;
        return amounts;
    }

    function getPrice(address tokenA, address tokenB) external view returns (uint price) {
        (uint reserveA, uint reserveB) = getReserves(tokenA, tokenB);
        require(reserveA > 0 && reserveB > 0, "NO_RESERVES");
        price = (reserveB * 1e18) / reserveA;
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public pure returns (uint amountOut) {
        require(amountIn > 0, "ZERO_INPUT");
        require(reserveIn > 0 && reserveOut > 0, "INSUFFICIENT_LIQUIDITY");
        
        uint numerator = amountIn * reserveOut;
        uint denominator = reserveIn + amountIn;
        amountOut = numerator / denominator;
    }
}