-- Add tx_hash column to complaints table
-- This stores the Ethereum transaction hash after minting to blockchain

ALTER TABLE complaints 
ADD COLUMN IF NOT EXISTS tx_hash TEXT;

-- Create index for faster queries on tx_hash
CREATE INDEX IF NOT EXISTS idx_complaints_tx_hash 
ON complaints(tx_hash);

-- Optional: Add comment
COMMENT ON COLUMN complaints.tx_hash IS 'Ethereum transaction hash from blockchain minting';
