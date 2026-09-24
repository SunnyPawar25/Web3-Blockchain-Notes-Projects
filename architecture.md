# Week 1 Architecture Notes

## 1. Ethereum high-level architecture

```text
                         Ethereum Network
                                |
              +-----------------+-----------------+
              |                                   |
          Consensus layer                    Execution layer
          (validator/proof of stake)        (EVM/state/tx execution)
              |                                   |
              +-----------------+-----------------+
                                |
                             Blocks
                                |
                         Global blockchain state
                                |
                    +-----------+-----------+
                    |                       |
                   EOAs                Contract accounts
                    |                       |
             sign transactions       execute smart contracts
                    |                       |
                    +-----------+-----------+
                                |
                               dApps
                                |
                    Wallet + frontend + RPC
```

## 2. Transaction flow

```text
1. User chooses a dApp action
        ↓
2. dApp prepares transaction/calldata
        ↓
3. Wallet asks user to approve/sign
        ↓
4. Signed transaction is sent to an RPC/node
        ↓
5. Network propagates it
        ↓
6. Validator includes it in a block
        ↓
7. EVM executes it
        ↓
8. Contract state/logs change
        ↓
9. dApp reads the resulting state
```

## 3. Smart-contract lifecycle

```text
Solidity source
      ↓
Compiler
      ↓
Bytecode + ABI
      ↓
Deployment transaction
      ↓
Contract address
      ↓
Calls / transactions
      ↓
EVM execution
      ↓
Storage + event logs
```

## 4. Security boundaries to annotate

When you redraw this for your final submission, mark these trust boundaries:

- Browser ↔ wallet
- dApp ↔ RPC provider
- Wallet ↔ signing prompt
- RPC ↔ Ethereum network
- User-controlled calldata ↔ smart contract
- Smart contract ↔ external contract
- Contract state ↔ frontend assumptions

These become very important in later Web3 security testing.
