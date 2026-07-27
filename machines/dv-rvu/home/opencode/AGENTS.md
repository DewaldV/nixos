# Agent Guidelines

## Git Commits

When making commits, always append a Co-Authored-By trailer to the commit message:

```
Co-Authored-By: Opencode {model-id} <noreply@opencode.ai>
```

Replace `{model-id}` with the actual model ID in use for the session (e.g. `claude-sonnet-4-6`).

## Git Worktrees

For concurrent work, use separate Git worktrees rather than sharing one checkout.

- Only modify files within the current worktree. Never edit files in a sibling worktree unless explicitly directed.
- Before creating a worktree, inspect the repository with `git worktree list`.
- Create one task-oriented branch and one worktree per independent unit of work.
- Do not remove worktrees, delete branches, or discard uncommitted changes unless explicitly asked.
- Do not run concurrent agent processes that can modify the same worktree.
- Check `git status` before making edits and before completing a task.
