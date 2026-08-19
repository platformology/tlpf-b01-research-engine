# B01 Render Upload Shell

This directory contains the minimal files needed to stand up the B01
Business Analysis / Research Engine from a bundled source archive on Render.

Files:

- `Dockerfile`: reassembles the split source bundle, installs root and embedded
  `client_ready_engine` dependencies, and starts the managed runtime
- `render.yaml`: Render blueprint for the hosted production-style web service
- `README.md`: notes for the hosted shell repo
- `overlay_bundle.tgz.base64`: valid empty overlay; the refreshed source bundle
  now carries the active hosted runtime and native-required B01 engine
- `deploy_bundle_source.tgz.part-aa`
- `deploy_bundle_source.tgz.part-ab`
- `EXISTING_WORK_INGESTION_AUDIT_B01_RENDER_2026_05_28.json`: audit receipt for
  the existing-work ingestion, install, assembly, wiring, and proof run

The source archive is generated from the local tree, split into upload-safe
parts smaller than GitHub's browser upload limit, and uploaded alongside these
files into the hosted GitHub repository used for Render testing.

The hosted runtime exposes `/api/health`, `/health`, `/health/ready`, and
`/api/status` for Render smoke testing. The active B01 program is the Business
Deconstruction / Research Engine, with the current native-required package
embedded at `/app/client_ready_engine` inside the Render container.

The runtime also exposes a public, read-only integration seam,
`GET /api/research/:reportId`, which returns the canonical structured research
report (the intelligence sections plus coverage and claim-gate metadata) for a
completed report id. Internal runtime fields (filesystem paths, hashes, and
downstream bundle plumbing) are redacted from this response, and unknown ids
return an honest-empty `404` with `status: REPORT_NOT_FOUND`. This is the seam
the book-campaign-platform spine calls to pull a finished B01 report.

Health and status responses no longer expose the internal engine path or
proof/debug command list to hosted or cross-origin callers; those diagnostics
are surfaced only to trusted-local requests outside the production profile.

## Repository size and maintenance

Measured on commit ce5df00. Recorded here because the shape of this repository
is misleading: GitHub reports the primary language as Dockerfile and roughly
0 MB of code, while the clone is 235 MB.

Where the size actually is:

- `git count-objects -vH` reports a 235.67 MiB pack.
- The checkout at HEAD is 35.4 MiB, and 10 files are tracked.
- Across all history there are 17 blob revisions of the split bundle and the
  base64 overlay, totalling 265,200,021 bytes. HEAD accounts for 37,148,229 of
  those bytes. The remaining 228,051,792 bytes (217.5 MiB) are superseded
  revisions of the same bundle, kept alive only by history.

So about 92 percent of a fresh clone is previous copies of the deployment
bundle. No pull request can reduce that number. Adding a smaller bundle only
appends more blobs to the pack. Shrinking the clone requires rewriting history
with a tool such as `git filter-repo` to drop the superseded bundle blobs,
followed by a force push. That is a destructive, coordinated operation and it
needs the repository owner to run it deliberately.

There is no code in this repository. The program source lives inside
`deploy_bundle_source.tgz.part-*`, which the Dockerfile concatenates, extracts
and copies to `/app`. That is why language statistics report no code. The
payload extracts to 203 MB.

Entry points, for anyone reading a program registry that disagrees:

- The container command is `npm run runtime:b01`, which runs
  `buildouts/buildout_01_research_engine/desktop_app/managedRuntime.js`.
- The engine module referenced elsewhere as `src/orchestrator.js` is actually at
  `client_ready_engine/src/orchestrator.js`. There is no `src/orchestrator.js`
  at the payload root; the payload's `src/` holds only `platform/`.

Two things to fix the next time the bundle is regenerated:

1. The bundle ignores the payload's own exclusion rules. The payload ships a
   `.dockerignore` and a `.gitignore` that both list `node_modules`,
   `03_REPORTS`, `buildouts/buildout_01_research_engine/desktop_app/.b01_app_state`
   and `buildouts/buildout_01_research_engine/outputs/desktop_app`, yet all four
   are present in the archive: 27.5 MB of `client_ready_engine/node_modules`,
   3.75 MB of `03_REPORTS`, 812 KB of `.b01_app_state` and 5.5 MB of
   `outputs/desktop_app`, plus 860 KB of `.pyc` files and one `.DS_Store`.
   The bundle is produced with `tar` straight from the working tree, which does
   not consult either ignore file. Excluding those paths produces a 29,777,225
   byte archive instead of 37,147,764, a saving of 7,370,539 bytes. The
   committed `node_modules` is safe to drop: the Dockerfile already runs
   `npm --prefix /app/client_ready_engine install --omit=dev`, a
   `client_ready_engine/package-lock.json` is present, and the root
   `npm install --omit=dev` must already reach the npm registry because the root
   `pg` dependency is not vendored. Do this at the same time as the history
   rewrite, not as a separate commit.

2. The Dockerfile reassembles the bundle with the glob
   `cat /tmp/deploy_bundle_source.tgz.part-*`. A third part existed once: it was
   added in dfe4bc3 and removed in 95e7f60. If a stale `part-ac` ever reappears
   in a working tree or an upload, the glob will silently concatenate it and
   corrupt the archive. Prefer listing the parts explicitly.
