FROM pandoc/latex:latest

# ── Diagram engines ───────────────────────────────────────────
# graphviz (dot), plantuml (pulls java), DejaVu fonts for PDF,
# chromium + node for Mermaid CLI
RUN apk add --no-cache \
    graphviz \
    plantuml \
    ttf-dejavu \
    nodejs \
    npm \
    chromium

# ── Mermaid CLI ───────────────────────────────────────────────
# Skip bundled Chromium; use the system one
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

RUN npm install -g @mermaid-js/mermaid-cli

# Wrap mmdc to disable Chromium sandbox (required inside Docker)
RUN printf '{"args":["--no-sandbox","--disable-setuid-sandbox"]}' \
      > /etc/mmdc-puppeteer.json \
 && mv /usr/local/bin/mmdc /usr/local/bin/mmdc.bin \
 && printf '#!/bin/sh\nexec /usr/local/bin/mmdc.bin --puppeteerConfigFile /etc/mmdc-puppeteer.json "$@"\n' \
      > /usr/local/bin/mmdc \
 && chmod +x /usr/local/bin/mmdc

# ── Python / Flask ────────────────────────────────────────────
RUN apk add --no-cache python3 py3-pip \
 && python3 -m venv /venv \
 && /venv/bin/pip install --no-cache-dir flask

ENV PATH="/venv/bin:$PATH"

WORKDIR /app
COPY frontend/ .
COPY pandoc/ pandoc/

EXPOSE 8080

ENTRYPOINT []
CMD ["python3", "app.py"]
