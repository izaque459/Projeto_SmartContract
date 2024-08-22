
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

// interface para smartcontract
interface IERC20{

    //getters
	//suprimento total de tokens no contrato
    function totalSupply() external view returns(uint256);
	//saldo em determinado endereço
    function balanceOf(address account) external view returns (uint256);
	//disponibiliza limite definido e atual
    function allowance(address owner, address spender) external view returns (uint256);

    //functions
	//usar o valor disponibizado por allowance
    function transfer(address recipient, uint256 amount) external returns (bool);
	//aprova transação de alguém gastar determinado de determinado saldo
    function approve(address spender, uint256 amount) external returns (bool);
	//trabalha com endereços de carteira de envio e recebimento de tokens
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    //events 
	//evento disparado no transfer
    event Transfer(address indexed from, address indexed to, uint256 value);
	//evento disparado na aprovação
    event Approval(address indexed owner, address indexed spender, uint256);

}

contract DIOCoin is IERC20{

    string public constant name = "DIO Token";
    string public constant symbol = "DIO";
    uint8 public constant decimals = 18;

    mapping (address => uint256) balances;

    mapping(address => mapping(address=>uint256)) allowed;

    uint256 totalSupply_ = 10 ether;

    constructor(){
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256){
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

}