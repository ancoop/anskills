# business-plan-research

Turn a business idea into a fact-based, citation-backed business plan published as a Google Doc.

## What it does

When you describe a business idea, Claude will:

1. Ask a short intake (idea, geography, stage, depth, known competitors).
2. Spawn 6 parallel research agents (problem/solution, market, competition, traction, GTM, execution).
3. Synthesize findings into a 14-section plan with inline citations and counter-evidence.
4. Generate 2–5 charts via quickchart.io.
5. Upload the assembled HTML as a Google Doc and return the link.

## Requirements

- Claude Code with web access (WebSearch + WebFetch)
- The Google Drive MCP server connected (used to create the final Doc). The skill falls back to plain text if conversion fails.

## Usage

After installing, just describe an idea:

```
I want to start a subscription service that ships fresh pasta kits to home cooks in the US.
Can you put together a business plan?
```

Claude will invoke the skill automatically. You can also trigger it explicitly:

```
Use the business-plan-research skill to research <my idea>.
```

## Output

A Google Doc titled `Business Plan: <idea> — <YYYY-MM-DD>` containing:

- 14 standard sections (problem, solution, market, competition, GTM, monetization, traction, team, ask, summary)
- Inline `[N]` citations linking to a Works Cited list
- 2–5 embedded charts
- Tables for comparison data

The skill is unbiased by design — every claim has a citation, every major section includes at least one risk or counter-evidence point, and hype adjectives are banned.
