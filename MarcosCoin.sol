// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title MarcosCoin - Um token ERC-20 padrão
contract MarcosCoin {
    string public name = "MarcosCoin";              // Nome do token
    string public symbol = "MCO";                   // Símbolo do token
    uint8 public decimals = 18;                     // Casas decimais (padrão para tokens fungíveis)
    uint256 public totalSupply;                     // Quantidade total de tokens emitidos

    mapping(address => uint256) public balanceOf;   // Saldo de cada endereço
    mapping(address => mapping(address => uint256)) public allowance; // Permissões delegadas

    /// Evento de transferência (requerido pelo padrão ERC-20)
    event Transfer(address indexed from, address indexed to, uint256 value);

    /// Evento de aprovação de gasto (requerido pelo padrão ERC-20)
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /// Construtor: emite todos os tokens para quem implantar o contrato
    constructor(uint256 _initialSupply) {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
        emit Transfer(address(0), msg.sender, _initialSupply);
    }

    /// Transfere tokens para outro endereço
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Saldo insuficiente.");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /// Autoriza outro endereço a gastar tokens em seu nome
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /// Realiza uma transferência em nome de outro endereço autorizado
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Saldo insuficiente.");
        require(allowance[_from][msg.sender] >= _value, "Sem permissao suficiente.");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
