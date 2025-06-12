Sure! Here's the **raw Markdown** content for your `README.md`:

---

```markdown
# Docker-izing DIMSpec

This project wraps the full DIMSpec environment—including R, Miniconda, RDKit, SQLite, Shiny apps, and a Plumber API—inside a single Docker container for **portable, reproducible installation**.

## ✅ Features

- R ≥ 4.3 with all DIMSpec R packages and source code
- Python 3.10 + RDKit via Miniconda, exposed to R via `reticulate`
- SQLite CLI + libraries
- Automatically starts:
  - Plumber API (port `8000`)
  - All 3 DIMSpec Shiny apps (port `3838`)
- Works on Linux, macOS, Windows (with Docker)
- No local R/Python setup needed

---

## 📁 Project Structure

```

.
├── Dockerfile                  # Main image build instructions
├── docker/
│   └── install\_packages.R      # Pre-install required R packages
├── docker-compose.yml          # Optional compose setup
├── build\_and\_run.sh            # Build & run helper script
└── data/                       # Persistent SQLite DB mount

````

---

## 🚀 Quick Start

### 1. Prerequisites

- Docker (or Podman) installed

### 2. Clone this repo and build the image

```bash
./build_and_run.sh
````

This will:

* Build the Docker image `nist/dimspec:latest`
* Start a container named `dimspec`
* Expose required ports and mount `./data/` to persist the database

### 3. Access the interfaces

* **Shiny apps**: [http://localhost:3838](http://localhost:3838)
* **Plumber API (Swagger UI)**: [http://localhost:8000/**docs**](http://localhost:8000/__docs__)

---

## 🛠 Custom Configuration

If you want to use your own `env_glob.txt` configuration:

```bash
docker run -d --name dimspec \
  -p 3838:3838 -p 8000:8000 \
  -v $(pwd)/env_glob.txt:/opt/DIMSpec/config/env_glob.txt:ro \
  -v $(pwd)/data:/opt/DIMSpec/db \
  nist/dimspec:latest
```

You can mount other files (e.g., custom R scripts) the same way or bake them into a derived image.

---

## 🐳 Using Docker Compose (optional)

If you prefer `docker-compose`, you can launch with:

```bash
docker compose up -d
```

Make sure `docker-compose.yml` exists:

```yaml
version: "3.9"
services:
  dimspec:
    build: .
    container_name: dimspec
    ports:
      - "3838:3838"
      - "8000:8000"
    volumes:
      - ./data:/opt/DIMSpec/db
      - ./env_glob.txt:/opt/DIMSpec/config/env_glob.txt:ro
```

---

## 🧪 Troubleshooting

* **First start takes longer**: The compliance script starts all services and caches packages.
* **Interactive R console**: Run `docker exec -it dimspec R`.
* **Conda / RDKit issues**: Ensure `/opt/conda/bin` is first in `PATH` (image does this).
* **Rebuild with cache cleared**:

  ```bash
  docker build --no-cache -t nist/dimspec .
  ```

---

## ✅ Summary

This setup gives you a **fully reproducible, isolated DIMSpec environment** with:

* No installation pollution
* Docker-based portability
* Persistent SQLite data on the host
* Identical ports and workflow to the official Quick-Guide

You're now ready to develop with DIMSpec exactly as intended!

```

---

Would you like me to create and send you the actual `.md` file to download?
```
