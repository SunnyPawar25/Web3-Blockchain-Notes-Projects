# Week 1 Wallet + Transaction Lab

## Objective

Create a safe test wallet, receive Sepolia test ETH, perform a test transaction, and document the transaction lifecycle.

## Evidence to capture

- Wallet connected and showing Sepolia network
- Public wallet address (safe to show)
- Testnet balance
- Transaction approval/signing screen (do not reveal secrets)
- Transaction hash
- Explorer transaction page
- Optional: before/after balance

## Procedure

### A. Test wallet

Create or use a dedicated wallet for training. Do not use the account that stores real funds.

Record only:

```text
Network: Sepolia
Address: 0x...
```

Never record:

```text
Seed phrase
Private key
Password
Backup codes
```

### B. Get test ETH

Use a currently available Sepolia faucet listed by Ethereum's official networks documentation.

### C. Send a tiny test amount

Send a very small amount of Sepolia ETH to a second test address that you control, or use the transaction requested by the internship instructions/community.

Record:

```text
From:
To:
Value:
Network:
Transaction hash:
Block number:
Gas used:
Status:
Explorer URL:
```

### D. Explain the transaction

Your report should answer:

1. Who signed the transaction?
2. Which account paid the fee?
3. What is the nonce?
4. What is the transaction `to` field?
5. What is the `value`?
6. What is `data` for a contract call?
7. What is gas?
8. What makes the transaction verifiable on an explorer?

## Security observation

A transaction hash/address is normally public blockchain information. A private key or seed phrase is secret. Never confuse public identifiers with authorization secrets.
