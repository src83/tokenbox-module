CREATE TABLE IF NOT EXISTS hash_pool_v1 (sort UInt64, hash String) ENGINE = MergeTree() ORDER BY sort;
CREATE TABLE IF NOT EXISTS hash_pool_v2 (sort UInt64, hash String) ENGINE = MergeTree() ORDER BY sort;
CREATE TABLE IF NOT EXISTS hash_pool_v3 (sort UInt64, hash String) ENGINE = MergeTree() ORDER BY sort;
CREATE TABLE IF NOT EXISTS hash_pool_v4 (sort UInt64, hash String) ENGINE = MergeTree() ORDER BY sort;
CREATE TABLE IF NOT EXISTS hash_pool_v5 (sort UInt64, hash String) ENGINE = MergeTree() ORDER BY sort;
CREATE TABLE IF NOT EXISTS hash_pool_v6 (sort UInt64, hash String) ENGINE = MergeTree() ORDER BY sort;
