FROM alpine:latest
RUN apk add --no-cache socat tailscale
WORKDIR /app

# Entrypoint: start tailscale in userspace networking, then socat proxy
# Note: "tailscale nc" is used (instead of a raw TCP: address) because userspace-networking
# mode has no real tun device, so the OS can't route directly to tailnet IPs; "tailscale nc"
# dials out through tailscaled's own netstack via its LocalAPI socket instead.
CMD tailscaled --tun=userspace-networking & \
    tailscale up --authkey=${TS_AUTHKEY} --hostname=azure-proxy --accept-routes=true && \
    socat TCP-LISTEN:${PUBLIC_PORT},fork EXEC:"tailscale nc ${TAILSCALE_TARGET} ${TARGET_PORT}"
