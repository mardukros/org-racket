# org-racket

A monorepo integration of Racket organization repositories from https://github.com/racket/*

## Overview

This repository consolidates multiple Racket organization repositories into a single monorepo structure for easier management and unified development. Each repository from `https://github.com/racket/*` is cloned into its own subdirectory without Git submodules.

For example:
- `https://github.com/racket/racket` → `/racket` (in this repo)
- `https://github.com/racket/typed-racket` → `/typed-racket` (in this repo)

## Repository Structure

```
org-racket/
├── racket/           # Main Racket implementation
├── typed-racket/     # Typed Racket
├── drracket/         # DrRacket IDE
├── scribble/         # Documentation tool
├── plot/             # Plotting library
└── ...               # Other Racket repositories
```

## Integration Process

To integrate or update repositories from the Racket organization:

1. Edit `repos.txt` to specify which repositories to integrate (format: `owner/repo-name`)
2. Run the integration script:
   ```bash
   ./integrate-repos.sh
   ```
3. Review the changes and commit:
   ```bash
   git add .
   git commit -m "Integrate racket org repositories"
   git push
   ```

### Configuration

The `repos.txt` file contains the list of repositories to integrate. Each line should be in the format:
```
racket/repo-name
```

Comments (lines starting with `#`) and empty lines are ignored.

## Notes

- All integrated repositories have their `.git` directories removed to avoid submodule issues
- Repositories are cloned with `--depth 1` to minimize repository size
- Existing directories are not overwritten by the integration script

## License

This monorepo includes code from multiple Racket repositories, each with their own licenses. See the LICENSE file in each subdirectory for details.
