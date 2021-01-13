FROM quay.io/roboll/helmfile:helm3-v0.137.0

RUN apk update && \
    apk add bash-completion && \
    helm completion bash > /usr/share/bash-completion/completions/helm

COPY .bashrc /root/
