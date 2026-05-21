# anskills

A Claude Code **plugin marketplace** containing skills you can install with one command.

Plugins in this marketplace:

| Plugin | What it does |
|---|---|
| [`business-plan-research`](plugins/business-plan-research) | Turns a business idea into a citation-backed business plan published as a Google Doc. |

---

## Install (the fast way)

From inside Claude Code, run:

```
/plugin marketplace add ancoop/anskills
/plugin install business-plan-research@anskills
```

That's it. `ancoop/anskills` resolves to `https://github.com/ancoop/anskills`. If you've forked the repo or are hosting it elsewhere, substitute your `owner/repo` slug, full URL, or local path.

To verify:

```
/plugin list
```

You should see `business-plan-research` installed. Open a new Claude Code session and describe a business idea — the skill will activate automatically.

---

## Install from a local clone

If you've already cloned the repo (e.g. `~/repos/anskills`):

```
/plugin marketplace add ~/repos/anskills
/plugin install business-plan-research@anskills
```

Or run the helper script — it does both steps and confirms success:

```
./scripts/install.sh
```

`install.sh` defaults to the repo it's run from, so it works whether the repo lives in `~/repos/anskills`, `~/code/anskills`, or anywhere else.

---

## Install everything in the marketplace

```
./scripts/install-all.sh
```

This reads `.claude-plugin/marketplace.json` and installs every plugin listed there.

---

## Uninstall

```
/plugin uninstall business-plan-research@anskills
/plugin marketplace remove anskills
```

---

## Adding your own skill to this marketplace

The repo layout is the standard Claude Code plugin marketplace layout:

```
anskills/
├── .claude-plugin/
│   └── marketplace.json          # marketplace manifest (lists every plugin)
├── plugins/
│   └── <plugin-name>/
│       ├── .claude-plugin/
│       │   └── plugin.json       # plugin manifest
│       ├── skills/
│       │   └── <skill-name>/
│       │       └── SKILL.md      # the skill itself
│       └── README.md
└── scripts/
    ├── install.sh
    └── install-all.sh
```

To add a new skill:

1. Create `plugins/<your-skill>/` with the structure above.
2. Drop your `SKILL.md` into `plugins/<your-skill>/skills/<your-skill>/SKILL.md`.
3. Add an entry to the `plugins` array in `.claude-plugin/marketplace.json` (use `"source": "./plugins/<your-skill>"` for a local source).
4. Open a PR.

See the official [`claude-plugins-official`](https://github.com/anthropics/claude-plugins-public) marketplace for more examples.

---

## How Claude Code plugins work (in one paragraph)

A *marketplace* is a Git repo (or local directory) that contains a `.claude-plugin/marketplace.json` file listing one or more *plugins*. After you `/plugin marketplace add <source>`, Claude Code knows about the marketplace; `/plugin install <name>@<marketplace>` then pulls the plugin's files (skills, agents, commands, hooks, MCP servers — whatever it ships) into your local Claude Code. Skills auto-activate when their description matches what you're asking for.
