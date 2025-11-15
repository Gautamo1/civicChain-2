# Civic Reporter - Blockchain Backend

This backend automatically mints complaints to the Ethereum Sepolia testnet when they are submitted via the mobile app.

## 🚀 Setup Instructions

### 1. Install Dependencies

```bash
cd civic-backend
npm install
```

### 2. Database Setup

Add `tx_hash` column to your `complaints` table in Supabase:

```sql
ALTER TABLE complaints 
ADD COLUMN IF NOT EXISTS tx_hash TEXT;
```

### 3. Enable Realtime in Supabase

1. Go to your Supabase project dashboard
2. Navigate to **Database** → **Replication**
3. Find the `complaints` table
4. Enable **Realtime** for INSERT events

### 4. Environment Variables

The `.env` file is already configured with your values:

- `PRIVATE_KEY`: Your wallet private key (⚠️ **NEVER share this!**)
- `RPC_URL`: Infura Sepolia endpoint
- `CONTRACT_ADDRESS`: Your deployed smart contract address
- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_SERVICE_KEY`: Service role key (not anon key)
- `PORT`: Server port (default: 5000)

### 5. Start the Server

**Development (with auto-restart):**
```bash
npm run dev
```

**Production:**
```bash
npm start
```

## 📊 How It Works

1. **On Startup:**
   - Checks for existing complaints without `tx_hash`
   - Mints them to the blockchain sequentially
   - Updates database with transaction hash

2. **Realtime Monitoring:**
   - Listens for new complaint INSERTs via Supabase Realtime
   - Automatically mints new complaints to blockchain
   - Stores transaction hash in `tx_hash` column

3. **Data Stored on Blockchain:**
   - Complaint ID
   - Municipal/City ID
   - Category
   - Timestamp
   - Recorded by (wallet address)

## 🔗 API Endpoints

### Health Check
```bash
GET http://localhost:5000/health
```

### Get Complaint from Blockchain
```bash
GET http://localhost:5000/getComplaint/:id
```

Example:
```bash
curl http://localhost:5000/getComplaint/1
```

### Manual Complaint Logging (Optional)
```bash
POST http://localhost:5000/logComplaint
Content-Type: application/json

{
  "complaintId": 123,
  "city": "Mumbai",
  "category": "waste"
}
```

## 🧪 Testing

1. **Start the backend:**
   ```bash
   npm start
   ```

2. **Submit a complaint from your mobile app**

3. **Check the console output** - you should see:
   ```
   🆕 New complaint detected!
   📜 Processing complaint 123...
   ⛓ Calling smart contract...
   📤 Transaction sent: 0x...
   ✅ Transaction confirmed!
   💾 Database updated with tx_hash
   ```

4. **Verify in database:**
   - Check that `tx_hash` column is populated
   - Copy the transaction hash

5. **Verify on blockchain:**
   - Visit: https://sepolia.etherscan.io/
   - Paste your transaction hash
   - You should see your transaction!

## 🔐 Security Notes

- ⚠️ **NEVER commit `.env` file to Git**
- ⚠️ **NEVER share your private key**
- Use a dedicated wallet for backend operations
- In production, use environment variables (not .env file)
- Consider using AWS Secrets Manager or similar for production

## 🐛 Troubleshooting

**"Complaint already exists" error:**
- Each complaint ID can only be minted once
- Check if `tx_hash` is already set in database

**Nonce errors:**
- Wait a few seconds between transactions
- The backend already has a 2-second delay built in

**Insufficient funds:**
- Make sure your wallet has Sepolia ETH
- Get free testnet ETH from: https://sepoliafaucet.com/

**Supabase realtime not working:**
- Verify Realtime is enabled for `complaints` table
- Check that you're using the service role key, not anon key
- Ensure no RLS policies are blocking service role

## 📱 Mobile App Integration

The mobile app doesn't need any changes! The backend monitors the database automatically.

**Optional:** Display transaction hash in the app:

1. Add `tx_hash` to your complaint queries
2. Show blockchain verification status:
   ```tsx
   {complaint.tx_hash && (
     <Text>
       ✅ Verified on blockchain
       <Link href={`https://sepolia.etherscan.io/tx/${complaint.tx_hash}`}>
         View Transaction
       </Link>
     </Text>
   )}
   ```

## 🌐 Production Deployment

For production deployment (e.g., Heroku, Railway, AWS):

1. Set environment variables in platform settings
2. Use process.env instead of .env file
3. Consider using a dedicated server wallet
4. Set up monitoring and alerts
5. Use mainnet RPC and contract (after testing!)

## 📝 Smart Contract

The Solidity contract is deployed at:
```
0x7f03154d7e73710B218BA616bD2067C323F6430f
```

On Sepolia testnet. View on Etherscan:
https://sepolia.etherscan.io/address/0x7f03154d7e73710B218BA616bD2067C323F6430f

## 🎯 Next Steps

1. ✅ Start the backend server
2. ✅ Test with a new complaint
3. ✅ Verify transaction on Etherscan
4. 📱 (Optional) Show tx_hash in mobile app
5. 🌐 (Optional) Deploy to production server

---

**Need help?** Check the console logs - they're very detailed!
