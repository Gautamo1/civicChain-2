# Transfer Ownership Guide

## Your Setup
- **Deployment Wallet**: `0x85790B00C5579EdA37f6ab2E52dD505c25Ed4D34`
- **Backend Wallet**: `0x47c99aB5C9BB30c74052219A8F1f1e41c78A9c64` (needs to be owner)
- **Current Contract**: `0xf2ed8ace62a7edeeab90d81b34415ea7623391f9` (V1, needs replacement)

## Option 1: Deploy V2 from Backend Wallet (EASIEST)

1. **Import backend private key to MetaMask temporarily**:
   - MetaMask → Account menu → Import Account
   - Paste: `0xa93df8c6e3634732b7a0f53f8e8249f9f7271bd6ada26c13454e742034f26f76`
   - ⚠️ **Delete this account from MetaMask after deployment for security**

2. **Deploy ComplaintRegistryV2.sol** from this wallet in Remix
   - Environment: Injected Provider (MetaMask)
   - Network: Sepolia
   - Account: `0x47c99aB5C9BB30c74052219A8F1f1e41c78A9c64`
   - Deploy ✅

3. **Copy new contract address** and update `.env`:
   ```
   CONTRACT_ADDRESS=<new-v2-address>
   ```

4. **Remove the imported account from MetaMask** (security)

## Option 2: Deploy from Your Wallet, Then Transfer

1. **Deploy ComplaintRegistryV2.sol** in Remix from `0x85790B00C5579EdA37f6ab2E52dD505c25Ed4D34`

2. **Transfer ownership** (in Remix, after deployment):
   - Find `transferOwnership` function
   - Input: `0x47c99aB5C9BB30c74052219A8F1f1e41c78A9c64`
   - Click "transact"
   - Confirm in MetaMask

3. **Copy new contract address** and update `.env`:
   ```
   CONTRACT_ADDRESS=<new-v2-address>
   ```

## After Deployment

### Update Backend
```powershell
# Edit .env and set new CONTRACT_ADDRESS
# Then restart:
cd "C:\Users\kumar\OneDrive\Desktop\civic\civic-backend"
npm start
```

### Verify Ownership
The backend wallet must be owner, or you'll see errors like:
```
❌ Error: transaction failed: execution reverted: "Not authorized"
```

You can verify in Remix:
- Call `owner()` → should return `0x47c99aB5C9BB30c74052219A8F1f1e41c78A9c64`

## Test the Full Flow

1. **Create a new complaint** in your app
2. **Check backend logs**:
   ```
   ✅ Transaction confirmed!
   💾 Database updated with tx_hash for complaint X
   ```

3. **Verify status on-chain**:
   ```powershell
   node test-contract-version.js
   # Should show: Status: 0 (Pending)
   ```

4. **Mark complaint as verified** in app (Profile → Verify tab → Accept)

5. **Check backend logs**:
   ```
   🔄 Updating on-chain status for complaint X -> 1 (from 'verified')
   ⛓ Status update tx sent: 0x...
   ✅ Status update confirmed in tx: 0x...
   ```

6. **Check on Etherscan**:
   - Visit: https://sepolia.etherscan.io/address/<new-contract-address>
   - You should see TWO transactions:
     - First: `logComplaint` (status set to Pending)
     - Second: `updateComplaintStatus` (status set to Resolved)
