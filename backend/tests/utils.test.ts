import { DataSanitizer } from '../src/utils/sanitizer';
import { PaginationHelper } from '../src/utils/pagination';
import { CacheManager } from '../src/utils/cache';

describe('Backend Utilities Tests', () => {
  describe('DataSanitizer', () => {
    it('should escape HTML characters safely', () => {
      const malicious = '<script>alert("XSS")</script>&foo=bar';
      const escaped = DataSanitizer.escapeHtml(malicious);
      expect(escaped).not.toContain('<script>');
      expect(escaped).toContain('&lt;script&gt;');
      expect(escaped).toContain('&amp;foo=bar');
    });

    it('should normalize emails properly', () => {
      const email = '  Ravi.Prakash@AXIOUSLABS.ORG   ';
      expect(DataSanitizer.normalizeEmail(email)).toBe('ravi.prakash@axiouslabs.org');
    });

    it('should strip script tags and javascript pseudo-protocols', () => {
      const raw = 'Hello <script>doBadThings();</script> World';
      expect(DataSanitizer.stripScriptTags(raw)).toBe('Hello  World');
    });

    it('should sanitize search queries from injection characters', () => {
      const rawQuery = "SELECT * FROM users WHERE '1'='1';";
      const clean = DataSanitizer.sanitizeSearchQuery(rawQuery);
      expect(clean).not.toContain("'");
      expect(clean).not.toContain(';');
    });

    it('should trim string fields in nested objects', () => {
      const payload = {
        title: '   Software Engineer   ',
        tags: ['  TypeScript  ', '  Node.js '],
        metadata: {
          company: ' Axious Labs  ',
        },
      };

      const cleaned = DataSanitizer.trimStrings(payload);
      expect(cleaned.title).toBe('Software Engineer');
      expect(cleaned.tags[0]).toBe('TypeScript');
      expect(cleaned.metadata.company).toBe('Axious Labs');
    });
  });

  describe('PaginationHelper', () => {
    it('should parse and clamp page and limit parameters', () => {
      const parsed1 = PaginationHelper.parseParams({ page: '2', limit: '25' });
      expect(parsed1.page).toBe(2);
      expect(parsed1.limit).toBe(25);

      const parsed2 = PaginationHelper.parseParams({ page: '-5', limit: '500' });
      expect(parsed2.page).toBe(1);
      expect(parsed2.limit).toBe(100); // capped at max limit
    });

    it('should correctly compute pagination metadata', () => {
      const meta = PaginationHelper.computeMeta(45, 2, 10);
      expect(meta.page).toBe(2);
      expect(meta.limit).toBe(10);
      expect(meta.totalItems).toBe(45);
      expect(meta.totalPages).toBe(5);
      expect(meta.hasNextPage).toBe(true);
      expect(meta.hasPreviousPage).toBe(true);
    });

    it('should paginate an in-memory array correctly', () => {
      const items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = PaginationHelper.paginateArray(items, 2, 3);
      expect(result.items).toEqual([4, 5, 6]);
      expect(result.meta.page).toBe(2);
      expect(result.meta.totalPages).toBe(4);
    });
  });

  describe('CacheManager', () => {
    it('should store, retrieve, and delete cache keys', () => {
      const cache = new CacheManager(10);
      cache.set('key1', { role: 'AI Platform Engineer' });

      expect(cache.has('key1')).toBe(true);
      const val = cache.get<{ role: string }>('key1');
      expect(val?.role).toBe('AI Platform Engineer');

      cache.delete('key1');
      expect(cache.has('key1')).toBe(false);
      expect(cache.get('key1')).toBeNull();
    });

    it('should track hit and miss statistics', () => {
      const cache = new CacheManager(10);
      cache.set('foo', 'bar');

      cache.get('foo'); // hit
      cache.get('foo'); // hit
      cache.get('missing'); // miss

      const stats = cache.getStats();
      expect(stats.hits).toBe(2);
      expect(stats.misses).toBe(1);
      expect(stats.hitRatio).toBe(0.67);
    });

    it('should respect TTL expiration', async () => {
      const cache = new CacheManager(0.05); // 50ms TTL
      cache.set('short_lived', 'value');

      expect(cache.get('short_lived')).toBe('value');
      await new Promise((res) => setTimeout(res, 70));

      expect(cache.get('short_lived')).toBeNull();
    });
  });
});

