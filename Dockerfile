FROM quay.io/roboll/helmfile:helm3-v0.132.3

RUN apk update && \
    apk add bash-completion && \
    adduser -D -s /bin/bash getia && \
    helm completion bash > /usr/share/bash-completion/completions/helm

USER getia
COPY .bashrc /home/getia/
