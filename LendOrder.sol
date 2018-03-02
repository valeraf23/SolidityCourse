pragma solidity ^0.4.20;

contract OffChain {
 
    event NewOrder(uint id, uint _amount);

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
    
    function lendMoney(uint _amount) public onlyKnownUser() {
        var userName = userNameByAddr[msg.sender];
        var newOrder = Order(userName, _amount, uint32(now),"lend");
        uint id = orders.push(newOrder)-1;
        balanceByAddr[msg.sender] = balanceByAddr[msg.sender]+_amount;
        NewOrder(id, _amount);
    }
    
    function repayMoney(uint _amount) public onlyKnownUser() {
        // require(balanceByAddr[msg.sender] == _amount);
        require(balanceByAddr[msg.sender] >= _amount);
        
        var userName = userNameByAddr[msg.sender];
        var newOrder = Order(userName,_amount, uint32(now),"repay");
        uint id = orders.push(newOrder)-1;
        balanceByAddr[msg.sender] = balanceByAddr[msg.sender]-_amount;
        NewOrder(id, _amount);
    }
	
    function ShowBalance() public onlyKnownUser() view returns (uint) {
        return balanceByAddr[msg.sender];
    }
	
    modifier onlyKnownUser () {
        require(userIdByAddr[msg.sender] != 0);
        _;
    }
  
    function register(string _name) public {
        require(userIdByAddr[msg.sender] == 0);
        var nameHash = keccak256(_name);
        require(nameHash != keccak256("") && nameHash != keccak256(" "));
        userIdByAddr[msg.sender] = uint(nameHash);
        userNameByAddr[msg.sender] = _name;
    }
}
   