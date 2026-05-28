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
