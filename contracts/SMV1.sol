// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CryptoDNS {
    struct Domain {
        address owner;
        string data; // e.g., IPFS hash, address, metadata
    }

    mapping(string => Domain) public domains;

    event DomainRegistered(string indexed name, address indexed owner);
    event DomainUpdated(string indexed name, string data);
    event OwnershipTransferred(string indexed name, address indexed oldOwner, address indexed newOwner);

    modifier onlyOwner(string memory name) {
        require(domains[name].owner == msg.sender, "Not domain owner");
        _;
    }

    function register(string memory name, string memory data) external {
        require(domains[name].owner == address(0), "Domain already taken");
        domains[name] = Domain(msg.sender, data);
        emit DomainRegistered(name, msg.sender);
    }

    function resolve(string memory name) external view returns (string memory) {
        require(domains[name].owner != address(0), "Domain not registered");
        return domains[name].data;
    }

    function updateData(string memory name, string memory newData) external onlyOwner(name) {
        domains[name].data = newData;
        emit DomainUpdated(name, newData);
    }

    function transferOwnership(string memory name, address newOwner) external onlyOwner(name) {
        address oldOwner = domains[name].owner;
        domains[name].owner = newOwner;
        emit OwnershipTransferred(name, oldOwner, newOwner);
    }

    function ownerOf(string memory name) external view returns (address) {
        return domains[name].owner;
    }
}
