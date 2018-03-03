pragma solidity ^0.4.20;

import "./ownable.sol";

contract OffChain is Ownable{
 
    event NewOrder(uint id, uint _amount);
    event NewUser(string _userName);

    struct Order {
        string owner;
        uint amount;
        uint32 time;
        string typeOfOrder;
    }

    Order[] public orders;

    mapping (address => uint) balanceByAddr;
    mapping (address => uint) userIdByAddr; 
    mapping (address => string) userNameByAddr;
    
    function lendMoney(uint _amount) public onlyKnownUser() moreThanZero(_amount) {
        uint id = orders.push(Order(userNameByAddr[msg.sender], _amount, uint32(now),"lend")) - 1;
        balanceByAddr[msg.sender] = balanceByAddr[msg.sender] + _amount;
        NewOrder(id, _amount);
    }
    
    function repayMoney(uint _amount, address _debtorAddress) public onlyOwner() moreThanZero(_amount) {
        require(_debtorAddress > 0x0);
        require(balanceByAddr[_debtorAddress] >= _amount);
        uint id = orders.push(Order(userNameByAddr[_debtorAddress],_amount, uint32(now),"repay")) - 1;
        balanceByAddr[_debtorAddress] = balanceByAddr[_debtorAddress] - _amount;
        NewOrder(id, _amount);
    }
	
    function showBalance() public onlyKnownUser() view returns (uint) {
        return balanceByAddr[msg.sender];
    }
	
    modifier onlyKnownUser () {
        require(userIdByAddr[msg.sender] != 0);
        _;
    }
	
  modifier moreThanZero(uint _amount) {
       require(_amount > 0);
        _;
    }
	
    function register(string _name) public {
        require(msg.sender != owner);
        require(userIdByAddr[msg.sender] == 0);
        require(keccak256(_name) != keccak256("") && keccak256(_name) != keccak256(" "));
        userIdByAddr[msg.sender] = uint(keccak256(_name));
        userNameByAddr[msg.sender] = _name;
        NewUser(_name);
    }
}
   