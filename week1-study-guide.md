# Week 1 — Blockchain & Web3 Foundations (Beginner → Pentester Mental Model)

## 0. What you are actually learning

Think of Week 1 as learning the Web3 equivalent of HTTP/TCP/Linux basics before doing Web3 pentesting.

Your target mental model:

```text
User
  ↓
Wallet / EOA
  ↓ signs
Transaction / calldata
  ↓
RPC endpoint / node
  ↓
Ethereum network
  ↓
Validator + EVM execution
  ↓
Block / state update
  ↓
Smart contract state + logs
  ↓
Explorer / dApp reads the result
```

The key difference from ordinary Web2 is that the application often does not own the final source of truth. Smart-contract state and transactions are recorded on-chain, while a frontend/backend can act as a client around that state.

## 1. Blockchain basics

### Blockchain

A blockchain is a distributed state/ledger system where network participants maintain and verify a shared history. On Ethereum, the network is operated by nodes and the state transition is executed by the EVM.

### Block

A block is a batch of transactions plus block metadata. Validators propose blocks; other nodes verify and process them.

### Hash

A cryptographic hash maps input data to a fixed-size digest. Hashes are used throughout blockchain systems to link data structures, identify transactions/blocks, and support integrity proofs.

For pentesting, remember: a hash is **not encryption**. You do not decrypt a hash to get the original plaintext.

### Consensus

Consensus is how distributed participants agree on the canonical chain/state. Current Ethereum uses proof of stake. Validators participate using staked ETH and validator software.

### Node

A node is software participating in the network. In Ethereum, execution and consensus functionality are separated across client software. An RPC endpoint exposes methods that applications use to query state or submit requests.

## 2. Ethereum architecture

### EVM

The Ethereum Virtual Machine executes smart-contract bytecode deterministically. Every participating execution node follows the protocol rules to calculate the resulting state.

Useful pentester analogy:

- HTTP server → EVM execution environment
- API endpoint → RPC method / contract function
- Database row → contract storage slot/state
- Signed API action → signed blockchain transaction
- Application logs → contract event logs

The analogy is imperfect, but it helps when moving from Web2 to Web3 security.

### Accounts

Ethereum has two main account categories:

1. Externally Owned Account (EOA)
   - controlled by a private key
   - can initiate transactions
   - has an address and balance

2. Contract account
   - controlled by code
   - no private key
   - executes when called through the network

Important: a wallet is **not the account itself**. A wallet is an interface/application that manages or interacts with accounts and keys.

### Address

An Ethereum address is commonly shown as a hexadecimal `0x...` value. An EOA address is derived from its public key. Contract addresses identify deployed contracts.

### Private key

A private key is the secret used to authorize signatures. Whoever controls it can control the account. Treat it like a password that can directly authorize financial actions—but even more carefully.

Never put it in:

- GitHub
- README files
- screenshots
- `.env` committed to Git
- chat messages

## 3. Transactions — the thing you must understand before Web3 testing

A transaction is a cryptographically signed state-changing instruction initiated by an account.

Conceptually:

```text
transaction = {
  from,
  to,
  nonce,
  value,
  data,
  gasLimit,
  fee parameters,
  signature
}
```

The exact serialization and fee fields vary with transaction type, but these fields are the ones you should recognize first.

### `from`

The sender account.

### `to`

The destination account/contract. Contract creation uses a transaction with no normal recipient address.

### `value`

Native ETH value transferred with the transaction.

### `data`

Calldata for contract interactions. This is extremely important for a future smart-contract pentester because function selectors and ABI-encoded arguments live here.

### `nonce`

A per-account transaction counter. It helps enforce ordering and prevents replay of the same signed transaction under the same account nonce.

### Gas

Gas measures computational work. The transaction sender pays network fees according to the transaction's gas usage and fee parameters.

Think:

```text
fee paid ≈ gas used × effective gas price
```

Do not confuse:

- gas limit = maximum gas you allow the transaction to consume
- gas used = actual computation consumed
- gas price / fee parameters = how the fee is priced

## 4. Read vs write

This distinction is fundamental for dApp testing.

### Read

A read/query retrieves existing contract state. It does not change blockchain state and normally does not require a signed transaction or gas payment from the user.

### Write

A write changes state. It requires a transaction and therefore a signature, inclusion in a block, and fees.

Examples:

```text
read: balanceOf(address)
write: transfer(to, amount)

read: owner()
write: transferOwnership(newOwner)
```

For future pentesting, this becomes a core testing split:

```text
Can I call it?
Can I read it?
Can I make it change state?
Which account is allowed to do that?
What calldata is sent?
What events/logs are emitted?
```

## 5. Wallets

For this internship, create a dedicated **test wallet** in MetaMask (or another wallet supported by your environment).

Wallet mental model:

```text
Wallet UI
   ↓
private key / signing capability
   ↓
account address
   ↓
signs transaction
   ↓
RPC / node
```

The wallet should never be treated as the blockchain database. It is your interface to account/key management and transaction signing.

## 6. Networks

You should understand:

- Mainnet = production Ethereum network
- Testnet = development/testing network
- Local development chain = blockchain running locally for development

For current Ethereum application development, the official docs list **Sepolia** as the recommended default public testnet for application development. Use test ETH only; testnet ETH has no real-world value.

## 7. RPC

RPC is how software talks to an Ethereum node/provider.

A dApp may perform requests similar to:

```text
eth_chainId
eth_getBalance
eth_call
eth_getTransactionByHash
eth_getTransactionReceipt
eth_blockNumber
```

Security relevance:

- RPC endpoints can expose metadata and blockchain state.
- Applications may trust RPC responses.
- Frontends may connect to user wallets and public/private RPC providers.
- Future testing should include transaction construction, calldata, chain ID, signing, and RPC trust boundaries.

## 8. Smart contracts

A smart contract is a program deployed at an Ethereum address. It contains code plus persistent state.

High-level lifecycle:

```text
Solidity source
   ↓ compile
EVM bytecode + ABI
   ↓ deployment transaction
contract address
   ↓
users/dApps call functions
   ↓
EVM executes code
   ↓
state + logs change
```

### ABI

ABI = Application Binary Interface.

It describes how to encode/decode calls and results for the contract interface.

For pentesting, ABI is very important because it tells you things such as:

- function names
- parameter types
- return types
- mutability (`view`, `pure`, `payable`, etc.)
- events
- custom errors

### Bytecode

The EVM executes compiled bytecode, not Solidity source directly.

### Storage

State variables persist in blockchain state. Storage is expensive compared with transient computation, which is why gas optimization and storage layout matter.

### Events

Events create logs associated with a transaction and contract address. Frontends and monitoring systems frequently consume them.

## 9. Solidity concepts needed this week

You do not need to master Solidity yet. Understand:

```solidity
contract Name {
    uint256 public value;

    function setValue(uint256 newValue) external {
        value = newValue;
    }

    function getValue() external view returns (uint256) {
        return value;
    }
}
```

Recognize:

- `contract` → contract definition
- `uint256` → 256-bit unsigned integer
- `public` → external access with compiler-generated getter for a public state variable
- `external` → callable from outside the contract
- `view` → function promises not to modify state
- `returns` → return type
- state variable → persistent blockchain state

## 10. Week 1 lab goal

Build a minimal storage contract in Remix.

Recommended flow:

1. Create a dedicated test wallet.
2. Enable/select Sepolia in the wallet.
3. Get a small amount of Sepolia test ETH from a faucet.
4. Open Remix IDE.
5. Create `BasicStorage.sol`.
6. Compile it with a current compatible Solidity 0.8.x compiler.
7. Deploy using the wallet/provider environment.
8. Capture the deployment transaction hash.
9. Capture the contract address.
10. Call a read function.
11. Call a write function.
12. Verify the transaction in a Sepolia explorer.
13. Commit the source and documentation to GitHub.

## 11. Pentester bridge: what Week 1 prepares you for

You are coming from VAPT/AppSec, so map the concepts like this:

| Web2 | Web3 equivalent / nearby concept |
|---|---|
| HTTP request | transaction / contract call |
| API endpoint | contract function / RPC method |
| request body | calldata / ABI-encoded arguments |
| authentication | wallet signature / account authority |
| authorization | contract access-control logic |
| DB state | contract storage |
| server-side code | smart-contract bytecode/EVM execution |
| logs | event logs / transaction traces |
| API gateway | RPC provider / node endpoint |
| deployment | contract deployment transaction |

This is not a 1:1 mapping. It is a bridge for your security mindset.

## 12. Don't jump into advanced vulnerabilities yet

Your future Web3 pentesting path should eventually include:

- reentrancy
- access-control failures
- broken authorization / ownership
- arithmetic/precision mistakes
- oracle manipulation
- flash-loan-assisted attacks
- signature/replay issues
- `delegatecall` risks
- upgradeable-contract risks
- proxy storage collisions
- unsafe external calls
- denial of service / gas griefing
- frontrunning / MEV-related issues
- bridge security
- token-standard edge cases

Week 1 is about learning enough architecture to understand what those attacks are attacking.
