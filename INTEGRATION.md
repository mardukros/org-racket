# Monorepo Integration Guide

## Quick Start

To integrate Racket organization repositories into this monorepo:

1. **Choose repositories to integrate**: Edit `repos.txt` or create your own configuration file
2. **Run the integration script**: 
   ```bash
   ./integrate-repos.sh [config-file]
   ```
3. **Commit the changes**:
   ```bash
   git add .
   git commit -m "Integrate racket repositories"
   git push
   ```

## Repository Configuration

The `repos.txt` file defines which repositories to integrate. Format:

```
# Comments start with #
owner/repository-name
```

Example:
```
racket/racket
racket/typed-racket
racket/drracket
```

## Integration Script Details

The `integrate-repos.sh` script:
- Clones repositories using shallow clone (`--depth 1`)
- Removes `.git` directories and `.gitmodules` files
- Places repositories in the root directory
- Skips existing directories to prevent overwrites

## Selective Integration

You can create multiple configuration files for different integration scenarios:

```bash
# Integrate only core repositories
./integrate-repos.sh core-repos.txt

# Integrate all repositories
./integrate-repos.sh repos.txt

# Integrate custom selection
./integrate-repos.sh my-repos.txt
```

## Repository Structure After Integration

```
org-racket/
├── .git/                    # This monorepo's git data
├── .gitignore              # Ignore patterns
├── README.md               # Main documentation
├── integrate-repos.sh      # Integration script
├── repos.txt               # Repository list
├── INTEGRATION.md          # This file
├── racket/                 # Integrated repository (no .git)
│   ├── src/
│   ├── README.md
│   └── ...
├── typed-racket/           # Integrated repository (no .git)
│   ├── typed-racket-lib/
│   └── ...
└── ...
```

## Updating Integrated Repositories

To update an integrated repository:

1. Remove the old directory: `rm -rf repository-name`
2. Re-run the integration script: `./integrate-repos.sh`

Or create an update script for specific repositories.

## Size Considerations

**Warning**: The `racket/racket` repository is quite large (hundreds of MB even with shallow clone). Consider:

- Integrating only the repositories you need
- Using shallow clones (already default in the script)
- Splitting into multiple monorepos by category (core, libraries, tools)

## Example Configurations

### Minimal (Core Only)
```
racket/racket
racket/typed-racket
racket/drracket
```

### Libraries Only
```
racket/plot
racket/math
racket/data
racket/net
```

### Tools and Documentation
```
racket/scribble
racket/redex
racket/rackunit
```

## Troubleshooting

### Repository fails to clone
- Verify the repository exists at `https://github.com/owner/repo`
- Check if the repository is private (this script only works with public repos)
- Ensure you have internet connectivity

### Directory already exists
- The script skips existing directories
- Remove the directory manually if you want to re-integrate: `rm -rf directory-name`

### Permission denied
- Ensure the script is executable: `chmod +x integrate-repos.sh`

## Automation

To automate integration in CI/CD:

```bash
#!/bin/bash
# Example CI integration
./integrate-repos.sh repos.txt
git add .
git diff --cached --exit-code || {
  git commit -m "Auto-update integrated repositories"
  git push
}
```

## Alternative: Using Git Subtree

If you prefer to maintain git history, consider using git subtree instead:

```bash
git subtree add --prefix racket https://github.com/racket/racket.git main --squash
```

However, this approach differs from the flat integration without .git directories that this repository implements.
