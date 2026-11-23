/**
 * In-Memory TTL Cache Manager
 * Provides lightweight, fast caching for frequent queries like market insights & skills catalogs.
 */

interface CacheEntry<T> {
  value: T;
  expiresAt: number;
}

export class CacheManager {
  private store = new Map<string, CacheEntry<any>>();
  private hits = 0;
  private misses = 0;

  constructor(private defaultTtlSeconds: number = 300) {}

  /**
   * Retrieve a value from the cache if not expired
   */
  get<T>(key: string): T | null {
    const entry = this.store.get(key);
    if (!entry) {
      this.misses++;
      return null;
    }

    if (Date.now() > entry.expiresAt) {
      this.store.delete(key);
      this.misses++;
      return null;
    }

    this.hits++;
    return entry.value as T;
  }

  /**
   * Set a value in the cache with an optional custom TTL
   */
  set<T>(key: string, value: T, ttlSeconds?: number): void {
    const ttl = ttlSeconds !== undefined ? ttlSeconds : this.defaultTtlSeconds;
    this.store.set(key, {
      value,
      expiresAt: Date.now() + ttl * 1000,
    });
  }

  /**
   * Check if a valid unexpired key exists
   */
  has(key: string): boolean {
    return this.get(key) !== null;
  }

  /**
   * Delete a key from cache
   */
  delete(key: string): boolean {
    return this.store.delete(key);
  }

  /**
   * Flush all entries from cache
   */
  flush(): void {
    this.store.clear();
    this.hits = 0;
    this.misses = 0;
  }

  /**
   * Retrieve cache diagnostics and hit/miss statistics
   */
  getStats(): { size: number; hits: number; misses: number; hitRatio: number } {
    const total = this.hits + this.misses;
    const hitRatio = total > 0 ? parseFloat((this.hits / total).toFixed(2)) : 0;
    return {
      size: this.store.size,
      hits: this.hits,
      misses: this.misses,
      hitRatio,
    };
  }
}

export const globalCache = new CacheManager(600); // 10 minutes default

