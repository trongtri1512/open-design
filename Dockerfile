FROM node:24-bullseye

WORKDIR /app

# Copy lockfile and package config first to leverage Docker cache
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

# Enable corepack and install pnpm
RUN corepack enable

# Copy all source code
COPY apps apps/
COPY packages packages/
COPY tools tools/
COPY skills skills/
COPY docs docs/
COPY design-systems design-systems/

# Install dependencies
RUN pnpm install

# Build the desktop package (required step in original tools-dev)
RUN pnpm --filter "@open-design/desktop" build || true

EXPOSE 3030
EXPOSE 7456

ENV HOSTNAME=0.0.0.0
ENV OD_BIND_HOST=0.0.0.0

CMD ["pnpm", "tools-dev", "run", "web", "--web-port", "3030", "--daemon-port", "7456"]
