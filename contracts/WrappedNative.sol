pragma solidity ^0.5.15;


// From: https://etherscan.io/address/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2#code
contract WrappedNative {
    string public name;
    string public symbol;
    uint8  public decimals = 18;

    event  Approval(address indexed src, address indexed guy, uint wad);
    event  Transfer(address indexed src, address indexed dst, uint wad);
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);

    mapping (address => uint) public  balanceOf;
    mapping (address => mapping (address => uint)) public allowance;

    constructor(string memory _name, string memory _symbol)
        public
    {
        name = _name;
        symbol = _symbol;
    }

    function()
        external
        payable
    {
        deposit();
    }

    function deposit()
        public
        payable
    {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint wad)
        public
    {
        require(balanceOf[msg.sender] >= wad, "Insufficient funds");
        balanceOf[msg.sender] -= wad;
        msg.sender.transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }

    function totalSupply()
        public
        view
        returns (uint)
    {
        return address(this).balance;
    }

    function approve(address guy, uint wad)
        public
        returns (bool)
    {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint wad)
        public
        returns (bool)
    {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        returns (bool)
    {
        require(balanceOf[src] >= wad, "Insufficient funds");

        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
            require(allowance[src][msg.sender] >= wad, "Insufficient funds");
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);

        return true;
    }
}
