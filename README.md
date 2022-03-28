# Smart accounts - example

This is an example of using 'smart accounts' -- smart contracts owned by an end-user wallet letting the user perform multiple actions
to different contracts in a single transaction.

The end-user owned smart contract is `src/SmartAccount.sol`. This contract is a modified version of [`prb-proxy`](https://github.com/paulrberg/prb-proxy). (See changelog in the contract file).

The example flow can be found in `src/test/SmartAccount.t.sol`. The tests enact the following high level flow: the end user mints 
some ERC20 and ERC721 tokens (two actions on two different smart contracts) within a single transaction. The application developer or
end user can choose whether the assets remain in the end-user owned/controlled smart contract wallet, or in the end-user's owned wallet.

## How to run tests

The tests are written using the foundry/forge testing framework. All setup information for foundry/forge can be found [here](https://github.com/gakonst/foundry).

To run tests:
```
forge build
```
then:
```
forge test --match-contract SmartAccount
```

### Authors
- [thirdweb](https://thirdweb.com/)