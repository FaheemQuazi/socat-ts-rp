FROM alpine:latest
RUN apk add --no-cache socat tailscale
WORKDIR /app

# Entrypoint: start tailscale in userspace networking, then socat proxy
CMD tailscaled --tun=userspace-networking & \
    tailscale up --authkey=${TS_AUTHKEY} --hostname=azure-proxy --accept-routes=true && \
    socat TCP-LISTEN:${PUBLIC_PORT},fork TCP:${TAILSCALE_TARGET}:${TARGET_PORT}
