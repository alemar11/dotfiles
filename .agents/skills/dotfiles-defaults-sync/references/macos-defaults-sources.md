# macOS Defaults Reference Sources

Most common macOS defaults are documented on:
- https://macos-defaults.com/

When updating or adding keys, you may also want to inspect the source repository:
- https://github.com/yannbertrand/macos-defaults

Suggested usage for this skill:
1. Clone the repository into a temporary directory when you need key descriptions.
2. Search for the target domain/key to find a matching description.
3. If the repo appears accurate for that key, use that description when documenting the key/value in `macos/defaults.sh` (or related audit docs).
4. If no reliable match is found, do not invent descriptions; keep wording conservative.

Notes:
- Prefer domain/key matches over fuzzy text matches.
- Treat descriptions as references, not ground truth; local behavior on current macOS remains authoritative.
