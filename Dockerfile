FROM node:24-bullseye

WORKDIR /app

# Enable corepack and install pnpm
RUN corepack enable

# Copy all source code (this ensures scripts/postinstall.mjs and everything else is present)
COPY . .

# Install dependencies
RUN pnpm install

# Build Next.js for production to avoid dev-mode memory crashes
RUN pnpm build

EXPOSE 3030
EXPOSE 7456

ENV HOSTNAME=0.0.0.0
ENV OD_BIND_HOST=0.0.0.0
ENV OD_HOST=0.0.0.0
ENV OD_DISABLE_CORS=1

CMD ["pnpm", "tools-dev", "run", "web", "--web-port", "3030", "--daemon-port", "7456", "--prod"]
