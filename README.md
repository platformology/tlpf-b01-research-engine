# B01 Render Upload Shell

This directory contains the minimal files needed to stand up the B01
Business Analysis / Research Engine from a bundled source archive on Render.

Files:

- `Dockerfile`: reassembles the split source bundle and starts the managed runtime
- `render.yaml`: Render blueprint for the test web service
- `README.md`: notes for the hosted shell repo
- `deploy_bundle_source.tgz.part-aa`
- `deploy_bundle_source.tgz.part-ab`
- `deploy_bundle_source.tgz.part-ac`

The source archive is generated from the local tree, split into upload-safe
parts smaller than GitHub's browser upload limit, and uploaded alongside these
files into the hosted GitHub repository used for Render testing.
