// SPDX-License-Identifier: MIT

pragma solidity >=0.5.1;

contract ERC20Token {
    string public name;
    string public symbol;
    address owner;
    mapping(address => uint256) public balances;

    constructor(string memory _name, string memory _symbol) public {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
    }

    function mint() public {
        balances[tx.origin] ++;
    }
}

contract TokenManager is ERC20Token {
    string public symbol;
    // token owners
    address[] public owners;
    uint256 public ownerCount;
    address payable public wallet;
    // single token costs 3 ETH
    uint256 conversion_rate = 3;
    uint256 eth_to_wei = 10 ** 18;

    constructor(string memory _name, string memory _symbol) ERC20Token(_name, _symbol) public { }

    function buyToken() public payable {
        //ethTransfer();
        mint();
    }

    function mint() public{
        super.mint();
        ownerCount ++;
        owners.push(msg.sender);
    }

    function ethTransfer() payable public{
        require(conversion_rate * eth_to_wei <= msg.value, "You need to spend more ETH!");
        wallet.transfer(msg.value);
    }

    function getPoolBalance() public view returns (uint256) {
        return address(this).balance;
    }

    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
        
    }
}
