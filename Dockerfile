FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Встановлюємо тільки необхідне для Python (git потрібен для деяких залежностей, curl — опціонально)
RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl ca-certificates && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копіюємо ВСЕ одразу (код + metadata)
COPY . .
# Встановлюємо nanobot (залежності + сам пакет)
RUN uv pip install --system --no-cache .

# Директорія для конфігу (на Render Free не persistent, тому ключі через env vars)
RUN mkdir -p /root/.nanobot

# Порт для gateway (якщо використовуєш web-інтерфейс або health-check)
EXPOSE 18790

# Запускаємо gateway (для Telegram та інших каналів)
ENTRYPOINT ["nanobot"]
CMD ["gateway"]
