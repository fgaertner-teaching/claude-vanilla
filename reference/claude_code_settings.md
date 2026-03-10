# Claude Code: Configuration & Security Reference

**Load when:** configuring Claude Code settings, permissions, hooks, or security.
**Skip when:** normal project work with no configuration changes.

Key settings and security notes. Sources: Backslash Security article (Sep 2025),
Boris Cherny creator tips (Feb 2026).

---

## Settings File Hierarchy

Claude Code merges settings from multiple files in priority order (highest last):

| File | Scope | Typical use |
|------|-------|-------------|
| `/Library/Application Support/ClaudeCode/managed-settings.json` (macOS) | Enterprise-wide | IT admins — enforces policy across all users |
| `~/.claude/settings.json` | User-wide | Personal defaults, permissions, hooks |
| `.claude/settings.json` (project root) | Project | Project-specific overrides, check into git |

On Windows, `managed-settings.json` lives in the equivalent system path (not yet documented by Anthropic).

---

## Security-Relevant Settings (`settings.json` or `managed-settings.json`)

| Setting | Recommended value | Notes |
|---------|------------------|-------|
| `cleanupPeriodDays` | `7` | Days before chat transcripts are deleted locally. Keep low (7–14) if working with sensitive data. |
| `disableAllHooks` | (leave unset for normal use) | When `true`, disables all hooks. An enterprise lockdown option. |
| `env` | Avoid secrets here | Sets env vars for all sessions. Use for non-secret config. Don't put credentials here. |
| `statusLine` | Read-only scripts only | If using a command-based status line, only run safe read-only scripts. |

**MCP servers:** Use an explicit allowlist. Never set `enableAllProjectMcpServers: true` — this auto-enables any MCP server defined in a project's config, which is a prompt injection / supply chain risk.

**Permissions:** Prefer an allowlist + denylist. The `"allow"` list pre-approves tool calls without prompting; the `"deny"` list blocks them outright. Wildcard syntax is supported: `"Bash(bun run *)"`, `"Edit(/docs/**)"`

---

## Custom Agents (`.claude/agents/`)

Drop `.md` files in `~/.claude/agents/` (global) or `.claude/agents/` (project) to define custom subagents.
Each agent file can specify: custom name, color, tool set, pre-allowed/pre-disallowed tools, permission mode, model.

To set the default agent for the main conversation, add `"agent": "agent-name"` to `settings.json` or use the `--agent` flag.

Run `/agents` to manage agents via the UI.

---

## Output Styles

Run `/config` to set an output style:
- **Explanatory** — Claude explains frameworks and patterns as it works. Useful when exploring a new codebase.
- **Learning** — Claude coaches you through making changes yourself.
- Custom styles can also be defined.

---

## Other Configuration Features (Quick Reference)

| Feature | How to access | Notes |
|---------|--------------|-------|
| Theme, notifications | `/config` | Light/dark, colorblind modes, ANSI-only |
| Newline in terminal | `/terminal-setup` | Enables Shift+Enter for newlines in supported terminals |
| Vim mode | `/vim` | |
| Effort level | `/model` | Low / Medium / High; creator recommends High |
| Plugins / MCPs / Skills | `/plugin` | Official Anthropic marketplace + custom |
| Sandbox | `/sandbox` | File + network isolation. **Windows support not yet available (as of Feb 2026).** |
| Keybindings | `/keybindings` | Every key binding customizable; settings live-reload |
| Hooks | `settings.json` → `"hooks"` key | PreToolUse, PostToolUse, PreCompact, etc. |
| Spinner verbs | Ask Claude or edit `settings.json` | Customize the "thinking" verb text |
| Env vars without wrapper scripts | `"env"` field in `settings.json` | 84 supported env vars as of Feb 2026 |

37 named settings and 84 env vars supported as of Feb 2026 — see official docs for full list.
