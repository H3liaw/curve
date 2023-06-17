
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

interface ICurveRouter {

   function get_best_rate(address from,address to,uint256 amount) external view returns(address,uint256);

    function exchange_multiple(address[9] memory _route,uint256[3][4] memory _swap_params,uint256 _amount,uint256 _expected,address[4] memory _pools,address _receiver)payable external returns(uint256);
}





contract CurvePool{

    address public constant CURVE_SWAP  = 0x2a426b3Bb4fa87488387545f15D01d81352732F9;


    // function filterSwap(bytes memory  exchangeData)  payable external{
    //     address inputAddre;
    //     address[9] memory route;
    //     uint256[3][4] memory swap_params;
    //     uint256 amount;
    //     uint256 expected;
    //     address[4] memory pools;
    //     address receiver;
    //    (inputAddre,route,swap_params,amount,expected,pools,receiver)  = abi.decode(exchangeData,(address,address[9],uint256[3][4],uint256,uint256,address[4],address));
    //     exchange_Multiples(inputAddre,route,swap_params,amount,expected,pools,receiver);
    // }


    function exchange_Multiples(address inputAddre,address[9] memory route,uint256[3][4] memory swap_params,uint256 amount,uint256 expected,address[4] memory pools,address receiver)payable external  {
     if (inputAddre == address(0)){
         require(msg.value == amount,"Price is wrong");
         ICurveRouter(CURVE_SWAP).exchange_multiple{value:amount}(route,swap_params,amount,expected,pools,receiver);
     }else{
        TransferHelper.safeTransferFrom(inputAddre,msg.sender,address(this),amount);
        TransferHelper.safeApprove(inputAddre,CURVE_SWAP,amount);
        TransferHelper.safeApprove(inputAddre,0xa1eE546E2a53e86EA7E1c5D017af3FEa1D1A9620,amount);
        ICurveRouter(CURVE_SWAP).exchange_multiple(route,swap_params,amount,expected,pools,receiver);
        }    
    }




}


library TransferHelper {
    using SafeMath for uint256;

    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::safeApprove: approve failed'
        );
    }

    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::safeTransfer: transfer failed'
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::transferFrom: transferFrom failed'
        );
    }
    
    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
    }
    
    
    function HelpRoyalties(address nftaddress, uint256 tokenId,uint256 _value) external view returns(address,uint256){
        
       (bool success, bytes memory data) =  nftaddress.staticcall(abi.encodeWithSignature("royaltyInfo(uint256,uint256)",tokenId,_value));
       
      if(success && data.length == 64){
          
          (address addr1,uint256 value1)=abi.decode(data, (address,uint256));
          if(addr1 != address(0) && value1 > 0 && value1 <= _value.mul(50).div(100)) {
               
                return( addr1,value1);
          }else if(value1 > _value.mul(50).div(100)){
              
              return (addr1,_value.mul(50).div(100));
              
          }
          
      }
       
      return(address(0),0);
        
       
    }
    
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
