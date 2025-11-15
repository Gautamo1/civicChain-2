# Deploy ComplaintRegistryV2 - Quick Guide

## What's happening
Your current contract (`0xf2ed8ace62a7edeeab90d81b34415ea7623391f9`) is **V1** and doesn't store status. You need to deploy **V2** which stores status on-chain (Pending → Resolved).

## Steps to Deploy V2

### 1. Open Remix IDE
Go to: https://remix.ethereum.org

### 2. Create the Contract File
- Create a new file: `ComplaintRegistryV2.sol`
- Copy the entire contract from: `civic-backend/contracts/ComplaintRegistryV2.sol`

### 3. Compile
- Compiler version: **0.8.20**
- Enable optimization: **Yes (200 runs)**
- Click "Compile ComplaintRegistryV2.sol"

### 4. Deploy (CRITICAL: Use Correct Wallet)
**IMPORTANT**: You MUST deploy from the wallet that matches your backend PRIVATE_KEY:

Your backend wallet address: `0x47c99aB5C9BB30c74052219A8F1f1e41c78A9c64`

In Remix:
- Environment: **Injected Provider - MetaMask**
- Network: **Sepolia** 
- Account: Make sure MetaMask shows `0x47c99aB5C9BB30c74052219A8F1f1e41c78A9c64`
  
  If not, import the private key from your .env into MetaMask temporarily for deployment.

- Click **Deploy**
- Confirm the transaction in MetaMask

### 5. Copy the New Contract Address
After deployment, copy the contract address from Remix (e.g., `0xABC...123`)

### 6. Update Backend .env
Replace the CONTRACT_ADDRESS in `.env`:
```
CONTRACT_ADDRESS=<paste-new-v2-address-here>
```

### 7. Restart Backend
```powershell
cd "C:\Users\kumar\OneDrive\Desktop\civic\civic-backend"
npm start
```

You should see:
- "✅ Subscribed to complaint status updates"
- "✨ Status sync is active..."

## Verify It Works

### Test 1: Check existing complaint
```powershell
node test-contract-version.js
```
Should show error because complaint 60 is on the old contract.

### Test 2: Create new complaint
- Add a new complaint in your app
- Backend should log: "Transaction confirmed!" with new tx_hash
- Visit: http://localhost:5000/getComplaint/<NEW_ID>
- Response should include: `"status": 0` (Pending)

### Test 3: Verify → Resolved flow
- Mark the new complaint as "verified" in your app
- Backend should log: "🔄 Updating on-chain status..."
- Backend should log: "✅ Status update confirmed in tx: 0x..."
- Check Etherscan: https://sepolia.etherscan.io/tx/<STATUS_UPDATE_TX>

## Quick Reference

Backend wallet (must be contract owner): `0x47c99aB5C9BB30c74052219A8F1f1e41c78A9c64`

Status mapping:
- 0 = Pending (set automatically when complaint is created)
- 1 = Resolved (set when app marks as "resolved" or "verified")
- 2 = Verified (available for future use)

Contract file location: `civic-backend/contracts/ComplaintRegistryV2.sol`
