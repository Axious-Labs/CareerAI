/**
 * Data Sanitizer & Security Utilities
 * Helps protect against XSS, input anomalies, and cleans incoming user payload data.
 */

export class DataSanitizer {
  private static readonly HTML_ESCAPE_MAP: Record<string, string> = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#x27;',
    '/': '&#x2F;',
  };

  /**
   * Escape standard HTML entities to mitigate Reflected XSS
   */
  static escapeHtml(input: string): string {
    if (!input) return '';
    return input.replace(/[&<>"'/]/g, (char) => DataSanitizer.HTML_ESCAPE_MAP[char] || char);
  }

  /**
   * Normalize an email address by trimming and lowercasing
   */
  static normalizeEmail(email: string): string {
    if (!email) return '';
    return email.trim().toLowerCase();
  }

  /**
   * Strip unsafe HTML/script tags from input strings
   */
  static stripScriptTags(input: string): string {
    if (!input) return '';
    return input
      .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
      .replace(/javascript:[^\s"'>]+/gi, '')
      .trim();
  }

  /**
   * Sanitize search keywords by stripping potential SQL injection and regex special chars
   */
  static sanitizeSearchQuery(query: string): string {
    if (!query) return '';
    return query
      .replace(/['";\\]/g, '') // strip quotes, semicolons, backslashes
      .replace(/[.*+?^${}()|[\]]/g, '') // strip regex specials
      .trim();
  }

  /**
   * Recursively trims string properties of a payload object
   */
  static trimStrings<T>(data: T): T {
    if (typeof data === 'string') {
      return (data as string).trim() as unknown as T;
    }
    if (Array.isArray(data)) {
      return data.map((item) => DataSanitizer.trimStrings(item)) as unknown as T;
    }
    if (data !== null && typeof data === 'object') {
      const sanitized: Record<string, any> = {};
      for (const [key, value] of Object.entries(data)) {
        sanitized[key] = DataSanitizer.trimStrings(value);
      }
      return sanitized as T;
    }
    return data;
  }
}

