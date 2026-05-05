FROM node:20-alpine

WORKDIR /bootstrap

COPY deploy_bundle_source.tgz.part-* /tmp/

RUN mkdir -p /app /tmp/src \
    && cat /tmp/deploy_bundle_source.tgz.part-* > /tmp/deploy_bundle_source.tgz \
    && tar -xzf /tmp/deploy_bundle_source.tgz -C /tmp/src \
    && cp -a /tmp/src/tlpf-b01-research-engine/. /app/ \
    && node -e "const fs=require('fs');const serverPath='/app/buildouts/buildout_01_research_engine/desktop_app/server.js';let serverSource=fs.readFileSync(serverPath,'utf8');serverSource=serverSource.replace('const acceptEncoding = String(req.headers[\"accept-encoding\"] || \"\");','const acceptEncoding = String(req?.headers?.[\"accept-encoding\"] || \"\");');serverSource=serverSource.replace('if ((req.headers[\"if-none-match\"] || \"\") === etag) {','if ((req?.headers?.[\"if-none-match\"] || \"\") === etag) {');if(!serverSource.includes('function requestHeaders(req) {')){serverSource=serverSource.replace('function applyCors(req, res) {','function requestHeaders(req) {\\n  return req?.headers || {};\\n}\\n\\nfunction applyCors(req, res) {');}serverSource=serverSource.replaceAll('req.headers.','requestHeaders(req).');serverSource=serverSource.replaceAll('req.headers[','requestHeaders(req)[');fs.writeFileSync(serverPath,serverSource);const modulesPath='/app/buildouts/buildout_01_research_engine/desktop_app/worldClassProductionModules.js';let modulesSource=fs.readFileSync(modulesPath,'utf8');modulesSource=modulesSource.replace('    client: [\"read_approved\", \"upload_locked\"],','    client: [\"read\", \"read_approved\", \"upload_locked\"],');modulesSource=modulesSource.replace('      if (updateError.message === \"NO_CHANGE_BLOCKED\") return current;','      if (updateError.message === \"NO_CHANGE_BLOCKED\") return current;\\n      if (updateError.message === \"CONCURRENT_UPDATE_CONFLICT\") {\\n        return adapter.read(collection, id);\\n      }');modulesSource=modulesSource.replace('    const monitoringCheck = await runMonitoringCheck(config);','    const monitoringCheck = await runMonitoringCheck(config, { persist: false });');modulesSource=modulesSource.replace('export async function runMonitoringCheck(config) {','export async function runMonitoringCheck(config, payload = {}) {');modulesSource=modulesSource.replace('  await writeJson(runtime.sink, {\\n    ...sinkState,\\n    latest_status: check.status,\\n    last_check_at: now(),\\n    last_check: check\\n  });','  if (payload.persist !== false) {\\n    await writeJson(runtime.sink, {\\n      ...sinkState,\\n      latest_status: check.status,\\n      last_check_at: now(),\\n      last_check: check\\n    });\\n  }');fs.writeFileSync(modulesPath,modulesSource);const appPath='/app/buildouts/buildout_01_research_engine/desktop_app/public/app.js';let appSource=fs.readFileSync(appPath,'utf8');appSource=appSource.replace('  await ensurePanelLoaded(\"dashboardPanel\");\\n','');appSource=appSource.replace('compactList(releaseChecks.slice(0, 4)','compactList((data.releaseChecks || []).slice(0, 4)');fs.writeFileSync(appPath,appSource);" \
    && rm -rf /tmp/src /tmp/deploy_bundle_source.tgz /tmp/deploy_bundle_source.tgz.part-* \
    && cd /app \
    && npm install --omit=dev

WORKDIR /app

ENV B01_APP_PROFILE=test \
    B01_APP_HOST=0.0.0.0 \
    B01_APP_AI_MODE=mock \
    B01_APP_OUTPUT_ROOT=/tmp/b01/outputs \
    B01_APP_STATE_ROOT=/tmp/b01/state \
    B01_DEPLOYMENT_TARGET=render_server_test

EXPOSE 10000

CMD ["npm", "run", "runtime:b01"]
