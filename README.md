# B01 Render Upload Shell

This directory contains the minimal files needed to stand up the B01
Business Analysis / Research Engine from a bundled source archive on Render.

Files:

- `Dockerfile`: reassembles the split source bundle, overlays current runtime
  patches, and starts the managed runtime
- `render.yaml`: Render blueprint for the hosted production-style web service
- `README.md`: notes for the hosted shell repo
- `overlay_bundle.tgz.base64`: compressed text-safe source overlay applied on
  top of the bundled archive
- `deploy_bundle_source.tgz.part-aa`
- `deploy_bundle_source.tgz.part-ab`
- `deploy_bundle_source.tgz.part-ac`

The source archive is generated from the local tree, split into upload-safe
parts smaller than GitHub's browser upload limit, and uploaded alongside these
files into the hosted GitHub repository used for Render testing.

The overlay bundle exists so hosted fixes can be shipped through text-safe
GitHub connector writes even when the source bundle itself is too large to
refresh in the current session.
