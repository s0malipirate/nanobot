FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Встановлюємо тільки необхідне для Python (git потрібен для деяких залежностей, curl — опціонально)
RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl ca-certificates && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копіюємо залежності спочатку (кеш-шар)
COPY pyproject.toml README.md LICENSE ./
RUN mkdir -p nanobot && touch nanobot/__init__.py && \
    uv pip install --system --no-cache . && \
    rm -rf nanobot

# Копіюємо весь код
COPY nanobot/ nanobot/

# Повторна інсталяція (для editable install або оновлень)
RUN uv pip install --system --no-cache .

# Директорія для конфігу (persistent не буде на Render Free, тому env vars важливіші)
RUN mkdir -p /root/.nanobot

# Порт для gateway (якщо використовуєш web-інтерфейс або health-check)
EXPOSE 18790

# Запускаємо gateway (для Telegram та інших каналів)
ENTRYPOINT ["nanobot"]
CMD ["gateway"]
