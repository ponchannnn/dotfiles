## Git commits in this repository

This is the `dotfiles` bare git repo (work-tree = `$HOME`). When committing here
(via the `dotfiles` alias), add the following trailer to every commit message:

```
Co-Authored-By: ogadra <61941819+ogadra@users.noreply.github.com>
```

Reason: several parts of this dotfiles setup (wezterm config, tmux config, the
`plus-pattern.png` asset, etc.) are adapted from https://github.com/ogadra/dotfiles.
This credits that source on commits touching or building on that work.

Do not add a "Co-Authored-By: Claude" trailer here (suppressed globally via
`attribution.commit` in `~/.claude/settings.json`).
