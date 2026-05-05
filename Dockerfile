FROM node:20-alpine

WORKDIR /bootstrap

COPY deploy_bundle_source.tgz.part-* /tmp/

RUN mkdir -p /app /tmp/src \
    && cat /tmp/deploy_bundle_source.tgz.part-* > /tmp/deploy_bundle_source.tgz \
    && tar -xzf /tmp/deploy_bundle_source.tgz -C /tmp/src \
    && cp -a /tmp/src/tlpf-b01-research-engine/. /app/ \
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
