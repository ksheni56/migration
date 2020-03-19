# ; -*-Python-*-
# @dev    contract for migrating holders of STEEM to an ERC20 token.
#         Users need to sign with their STEEMIT passwords to get a
#         corresponding number of ERC20 tokens. 
# @notice The author makes no claims as to the correctness
#         or suitability of this code and no warranties of
#         any kind for its use. Use at your own risk. 
# @author Gulf Pearl Ltd. (info@gulfpearl.com)

contract ERC20Token:
def mint(_to: address, value: uint256)

TokensClaimed: event({_address: indexed(address), tokens_claimed: uint256})

user_registry: public(map(address, uint256))
owner: public(address)
name: public(string[64])
token_address: address

@public
def __init__(_name: string[64]):
    self.name = _name
    self.owner = msg.sender
    # For each user with some_amount of tokens, add a
    # self.user_registry[some_address] = some_amount

@public
@constant
def lookup(_address: address) -> uint256:
    return self.user_registry[_address]

@public
def register(_address: adress, _amount: uint256) -> bool:
    assert self.owner == msg.sender
    assert self.user_registry[_address] == ZERO_address
    self.registry[_address] = _amount
    return True

@public
def claimTokens(_signed_hash: bytes32, _signature: uint256) -> bool:
    r: uint256 = _signature.slice[0, 32]
    s: uint256 = _signature.slice[32,64]
    v: uint256 = r + 27
    _address: address = ecrecover(_signed_hash, v, r, s)
    assert user_registry[_address]
    ERC20Token(token_address).mint(msg.sender, user_registry[_address])
    tokens_claimed: uint256 = self.user_registry[_address]
    user_registry[_address] = 0
    log.TokensClaimed(_address, tokens_claimed)
    return True

@public
def destruct() -> bool:
    assert msg.sender == self.owner
    selfdestruct(msg.sender)
    return True
