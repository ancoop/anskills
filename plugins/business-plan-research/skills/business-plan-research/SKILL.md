---
name: business-plan-research
description: Conduct unbiased, citation-backed market research for a business idea and produce a structured business plan as a Google Doc. Use when the user describes a business idea and wants market research, competitive analysis, or a written plan/pitch document. Spawns parallel research agents, synthesizes findings with inline citations, generates charts via quickchart.io, and uploads the final report as a Google Doc.
---

# Business Plan Research

This skill turns a business idea into a fact-based, citation-backed business plan document published to the user's Google Drive.

## Core principles (non-negotiable)

1. **Unbiased.** No hype language. Banned without specific supporting data: *revolutionary, massive, unprecedented, perfect storm, game-changing, disruptive, paradigm shift, exploding, booming, no-brainer*. Replace adjectives with specific numbers and citations.
2. **Every claim has a source.** Numbers, named entities, and market assertions get an inline citation. Internal logic (e.g. "this implies X follows from Y") does not need a citation but must be clearly derivative, not stated as fact.
3. **Counterevidence required.** Each major section must include at least one risk, skeptical data point, or contrary finding. A research document that only confirms is not research.
4. **Source quality tiers** (prefer top to bottom):
   - Government / industry-association data (Census, BLS, NGF, etc.)
   - Established trade publications and analyst reports
   - Company filings, press releases, funded-startup data (Crunchbase)
   - News articles
   - Forums/Reddit (only for sentiment, never for numbers)
   - SEO listicles ("Top 10 X of 2025") are last resort and never for original figures
5. **Recency.** Prefer sources <12 months old for market sizing and growth figures. Note `date_accessed` on every citation.

## Workflow

### Step 1: Intake

Ask the user these questions in a single AskUserQuestion call (or accept answers if already provided):

1. **Business idea** — one paragraph description (if not already given)
2. **Geography** — primary market (US, global, specific region)
3. **Stage** — pre-seed concept, prototype/beta, early revenue, growth
4. **Depth** — quick (~1500w, 10 sources), standard (~4000w, 30 sources), or deep (~7000w, 60+ sources). Default: standard.
5. **Known competitors or comparables** — anything they're already aware of (optional)

Do NOT skip intake. Without these the research will scope wrong.

### Step 2: Spawn parallel research agents

Spawn **6 `general-purpose` agents in parallel** (single message, multiple Agent tool calls). Each gets the business idea + intake answers + this contract:

> Return findings as structured markdown with a `## Findings` section (bulleted, each bullet a discrete fact) and a `## Citations` section (numbered list of `[N] Title — URL — date_accessed`). Inline-cite every fact with `[N]`. Prefer sources from the quality tiers in the skill description. Include at least 2 counterevidence or risk findings. Use WebSearch and WebFetch.

The six agents and their focus areas:

| Agent | Research focus |
|---|---|
| **problem-solution** | The problem being solved (with data on its scale/cost/frequency), how existing solutions fall short, technical feasibility of the proposed solution |
| **market-opportunity** | TAM/SAM/SOM, market growth rate, macro trends and demographic shifts, regulatory environment |
| **competition** | Direct competitors (product, pricing, funding, traction), indirect competitors, fragmented incumbents, market-share data |
| **traction-validation** | Comparable companies' funding/exit data, similar Kickstarter/crowdfunding outcomes, analogous product launches |
| **gtm-monetization** | Customer acquisition channels for this category, channel economics (CAC, conversion), pricing benchmarks, business model patterns |
| **execution-context** | Required team composition for this category, typical capital needs at stage, key milestones investors look for, hiring market for required skills |

### Step 3: Synthesize

After all agents return:

1. Build a **master citation index** — dedupe URLs across agents, renumber `[1]` through `[N]`.
2. Update inline citations in each agent's findings to the master index.
3. Draft the 12 required sections (below) by pulling from agent findings. Do not invent facts — every section must be traceable to agent output. If a section lacks data, say so explicitly rather than padding.

### Step 4: Required document structure

The plan must answer these 12 questions in this order:

1. **Hi, I'm [...] from [...]** — pull from intake or leave a `[FILL IN]` placeholder
2. **The Problem We're Solving** — scale, cost, who feels it
3. **Our Solution** — what it is, how it works, why now is feasible
4. **This is a Big Opportunity Because** — market size, growth, macro trends
5. **Our Target Market** — segments with characteristics and willingness to pay
6. **We Will Acquire Customers By** — specific channels with economics
7. **Our Current Traction Is** — or, for early stage, comparable validation
8. **We Make Money By** — revenue streams with realistic numbers
9. **Our Key Competition Is** — named competitors with funding and weaknesses
10. **We're Better Because** — specific, defensible differentiators (not adjectives)
11. **Our Team Is** — `[FILL IN]` placeholder unless user provided team info
12. **What We'll Do Next Is** — phased roadmap with milestones
13. **Currently, We Are Seeking** — `[FILL IN]` for capital/partnerships ask
14. **To Summarize** — one paragraph, no new claims

Use tables liberally for comparison data (the example pitch had ~10 tables — they carry data well and render natively in Google Docs).

### Step 5: Neutrality pass

Before generating charts, re-read the full draft once with this checklist:

- [ ] Search for banned adjectives (list above) — replace or delete
- [ ] Every numeric claim has `[N]` citation
- [ ] Every named company/product/figure has `[N]` citation
- [ ] At least one risk/counterevidence point per major section
- [ ] No "we will dominate / we are the leader / certain to" — replace with conditional language tied to specific milestones

### Step 6: Generate charts

Identify 2-5 data sets in the synthesized findings worth visualizing. Worth a chart only if:
- ≥3 comparable data points exist
- The *shape* of the data (trend, ranking, distribution) matters more than the exact numbers
- A table wouldn't communicate it as clearly

Render each via **quickchart.io**:

```
POST https://quickchart.io/chart
Content-Type: application/json
{
  "chart": { /* chart.js config object */ },
  "width": 700,
  "height": 400,
  "backgroundColor": "white",
  "format": "png"
}
```

Response is the PNG binary. Base64-encode and embed in HTML as `<img src="data:image/png;base64,...">`.

Use WebFetch or curl via Bash. Keep chart configs simple: bar, line, or doughnut. Always include axis labels and a title. Cite the data source below each chart.

### Step 7: Assemble HTML

Build a single self-contained `report.html` with:

- `<style>` block: clean serif body (Georgia/Charter), sans-serif headings, max-width ~720px, generous line-height (1.6), muted citation links
- `<h1>` plan title, `<h2>` for each of the 14 sections
- Tables with `<table>`, bordered, alternating row shading
- Charts as `<img>` with base64 data URIs
- Inline citations as `<sup><a href="#cite-N">[N]</a></sup>` linking to a Works Cited section at the bottom
- Works Cited section: numbered `<ol>` with title, source, link, date_accessed

Style reference — keep it sober and document-like, NOT marketing-flashy. This is a research artifact.

### Step 8: Upload to Google Drive

Use `mcp__claude_ai_Google_Drive__create_file`:

```
title: "Business Plan: [idea name] — [YYYY-MM-DD]"
contentMimeType: "text/html"
textContent: <the assembled HTML>
parentId: (omit — uploads to Drive root)
```

Drive will auto-convert HTML to a Google Doc. The response includes the file ID and webViewLink. Return the link to the user.

**If conversion fails** or the resulting Doc looks broken, fallback: upload as `text/plain` with markdown body. Inferior formatting but reliable.

### Step 9: Report back

Send the user a short message:
- Doc URL
- Source count
- Word count
- 2-3 sentence summary of the strongest finding AND the strongest risk surfaced

## Anti-patterns to avoid

- **Don't write the draft before research returns.** Wait for all 6 agents.
- **Don't paper over thin sections.** If `traction-validation` came back weak because the category is new, say "Limited direct comparables exist; the closest analogues are X and Y" — don't pad with adjectives.
- **Don't cite Wikipedia or AI-generated content** as a primary source for figures.
- **Don't generate charts of made-up data** to fill space. If the data isn't in the citations, the chart doesn't exist.
- **Don't ask the user to confirm each step.** The intake is the only interactive moment; everything after runs through.

## Customization

If the user wants a custom section, an alternate structure, or to emphasize a particular angle (e.g. heavy on regulatory analysis for a healthcare idea), accept the deviation but keep the core principles (citations, neutrality, counterevidence) intact.
