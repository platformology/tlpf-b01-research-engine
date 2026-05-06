FROM node:20-alpine

WORKDIR /bootstrap

COPY deploy_bundle_source.tgz.part-* /tmp/
COPY overlay_bundle.tgz.base64 /tmp/overlay_bundle.tgz.base64

RUN mkdir -p /app /tmp/src \
    && cat /tmp/deploy_bundle_source.tgz.part-* > /tmp/deploy_bundle_source.tgz \
    && base64 -d /tmp/overlay_bundle.tgz.base64 > /tmp/overlay_bundle.tgz \
    && tar -xzf /tmp/deploy_bundle_source.tgz -C /tmp/src \
    && cp -a /tmp/src/tlpf-b01-research-engine/. /app/ \
    && tar -xzf /tmp/overlay_bundle.tgz -C /app \
    && rm -rf /tmp/src /tmp/deploy_bundle_source.tgz /tmp/deploy_bundle_source.tgz.part-* /tmp/overlay_bundle.tgz /tmp/overlay_bundle.tgz.base64 \
    && cd /app \
    && npm install --omit=dev

WORKDIR /app

ENV B01_APP_HOST=0.0.0.0

EXPOSE 10000

CMD ["npm", "run", "runtime:b01"]
