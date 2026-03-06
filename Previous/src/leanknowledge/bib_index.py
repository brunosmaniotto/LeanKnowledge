from dataclasses import dataclass, asdict
from pathlib import Path
import json
import re

@dataclass
class BibEntry:
    """A parsed BibTeX entry."""
    key: str
    entry_type: str
    title: str
    authors: list[str]
    year: str
    publisher: str | None = None
    journal: str | None = None
    doi: str | None = None
    url: str | None = None
    raw_fields: dict[str, str] | None = None

    def to_dict(self):
        return asdict(self)

    @classmethod
    def from_dict(cls, data):
        return cls(**data)

class BibIndex:
    """Searchable index over Mathlib's references.bib."""

    DEFAULT_PATH = Path(".lake/packages/mathlib/docs/references.bib")
    CACHE_PATH = Path("bib_index.json")

    def __init__(self, bib_path: Path | None = None):
        self.bib_path = bib_path if bib_path else self.DEFAULT_PATH
        self._entries: list[BibEntry] = []
        self._loaded = False
        self._load()

    def _load(self):
        """Load entries from cache or parse from file."""
        if self.CACHE_PATH.exists():
            try:
                with open(self.CACHE_PATH, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    self._entries = [BibEntry.from_dict(d) for d in data]
                    self._loaded = True
                    return
            except Exception as e:
                print(f"Failed to load bib cache: {e}")

        if not self.bib_path.exists():
            print(f"Bib file not found at {self.bib_path}")
            return

        try:
            with open(self.bib_path, "r", encoding="utf-8") as f:
                content = f.read()
            self._entries = self._parse_bibtex(content)
            self._save_cache()
            self._loaded = True
        except Exception as e:
            print(f"Failed to parse bib file: {e}")

    def _save_cache(self):
        try:
            with open(self.CACHE_PATH, "w", encoding="utf-8") as f:
                json.dump([e.to_dict() for e in self._entries], f, indent=2)
        except Exception as e:
            print(f"Failed to save bib cache: {e}")

    def _parse_bibtex(self, content: str) -> list[BibEntry]:
        entries = []
        # Simple parser logic
        # Find all entries starting with @
        # We assume standard formatting: @Type{key, fields...}
        
        # Regex to find the start of an entry: @(\w+)\s*{\s*([^,]+),
        entry_start_re = re.compile(r'@([a-zA-Z]+)\s*{\s*([^,]+),', re.MULTILINE)
        
        pos = 0
        while True:
            match = entry_start_re.search(content, pos)
            if not match:
                break
            
            entry_type = match.group(1).lower()
            key = match.group(2).strip()
            start_fields = match.end()
            
            # Parse fields
            fields, end_pos = self._parse_fields(content, start_fields)
            pos = end_pos
            
            # Construct BibEntry
            # Clean up fields
            clean_fields = {k.lower(): self._clean_value(v) for k, v in fields.items()}
            
            # Extract common fields
            title = clean_fields.get("title", "")
            
            # Author parsing is complex, we'll do a simple split by " and "
            raw_authors = clean_fields.get("author", clean_fields.get("editor", ""))
            authors = [a.strip() for a in raw_authors.split(" and ")] if raw_authors else []
            
            year = clean_fields.get("year", "")
            publisher = clean_fields.get("publisher")
            journal = clean_fields.get("journal", clean_fields.get("booktitle")) # fallback to booktitle for proceedings
            doi = clean_fields.get("doi")
            url = clean_fields.get("url")
            
            entries.append(BibEntry(
                key=key,
                entry_type=entry_type,
                title=title,
                authors=authors,
                year=year,
                publisher=publisher,
                journal=journal,
                doi=doi,
                url=url,
                raw_fields=clean_fields
            ))
            
        return entries

    def _parse_fields(self, content: str, start_pos: int) -> tuple[dict[str, str], int]:
        fields = {}
        pos = start_pos
        n = len(content)
        
        while pos < n:
            # Skip whitespace
            while pos < n and content[pos].isspace():
                pos += 1
            
            if pos >= n:
                break
                
            # Check for end of entry
            if content[pos] == '}':
                return fields, pos + 1
            
            # Read key
            key_start = pos
            while pos < n and (content[pos].isalnum() or content[pos] in "-_"):
                pos += 1
            key = content[key_start:pos]
            
            # Skip whitespace and =
            while pos < n and content[pos].isspace():
                pos += 1
            if pos < n and content[pos] == '=':
                pos += 1
            else:
                # Should detect error or skip
                # If we hit '}', return
                if pos < n and content[pos] == '}':
                     return fields, pos + 1
                pos += 1 # advance to avoid infinite loop
                continue

            # Skip whitespace
            while pos < n and content[pos].isspace():
                pos += 1
            
            # Read value
            value = ""
            if pos < n:
                if content[pos] == '{':
                    # Braced value
                    pos += 1
                    brace_depth = 1
                    val_start = pos
                    while pos < n and brace_depth > 0:
                        if content[pos] == '{':
                            brace_depth += 1
                        elif content[pos] == '}':
                            brace_depth -= 1
                        pos += 1
                    value = content[val_start:pos-1]
                elif content[pos] == '"':
                    # Quoted value
                    pos += 1
                    val_start = pos
                    while pos < n and content[pos] != '"':
                        # Handle escaped quote? Standard BibTeX doesn't escape quotes like " inside ", 
                        # it uses braces usually. But let's assume simple.
                        pos += 1
                    value = content[val_start:pos]
                    pos += 1
                else:
                    # Raw value (number or string key)
                    val_start = pos
                    while pos < n and content[pos] not in ",}":
                        pos += 1
                    value = content[val_start:pos].strip()
            
            fields[key] = value
            
            # Skip whitespace and comma
            while pos < n and content[pos].isspace():
                pos += 1
            if pos < n and content[pos] == ',':
                pos += 1
        
        return fields, pos

    def _clean_value(self, value: str) -> str:
        # Remove newlines and extra spaces
        value = re.sub(r'\s+', ' ', value)
        # Remove TeX braces {}
        # Simple removal of outer braces? Or all braces?
        # Ideally we want to keep structure but remove formatting.
        # For simple search, removing all {} might be okay, or just outer.
        # Let's remove all curly braces for now to make it plain text searchable
        value = value.replace('{', '').replace('}', '')
        # Remove quotes if they wrapped the value (already handled by parser, but maybe internal ones?)
        return value.strip()

    @property
    def entries(self) -> list[BibEntry]:
        return self._entries

    def search_by_author(self, author: str) -> list[BibEntry]:
        """Find entries by author surname (case-insensitive substring match)."""
        query = author.lower()
        results = []
        for entry in self._entries:
            for auth in entry.authors:
                if query in auth.lower():
                    results.append(entry)
                    break
        return results

    def search_by_title(self, query: str) -> list[BibEntry]:
        """Find entries whose title contains the query (case-insensitive)."""
        q = query.lower()
        return [e for e in self._entries if q in e.title.lower()]

    def search_by_key(self, key: str) -> BibEntry | None:
        """Exact lookup by BibTeX key."""
        for entry in self._entries:
            if entry.key == key:
                return entry
        return None

    def search(self, query: str) -> list[BibEntry]:
        """Fuzzy search across author, title, and key. Returns best matches."""
        q = query.lower()
        results = []
        for entry in self._entries:
            score = 0
            if q in entry.key.lower():
                score += 3
            if q in entry.title.lower():
                score += 2
            for auth in entry.authors:
                if q in auth.lower():
                    score += 2
            
            if score > 0:
                results.append((score, entry))
        
        # Sort by score desc
        results.sort(key=lambda x: x[0], reverse=True)
        return [x[1] for x in results]
