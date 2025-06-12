
# Docker-izing DIMSpec

This project wraps the full DIMSpec environment—including R, Miniconda, RDKit, SQLite, Shiny apps, and a Plumber API—inside a single Docker container for **portable, reproducible installation**.

## ✅ Features

- R ≥ 4.3 with all DIMSpec R packages and source code
- Python 3.10 + RDKit via Miniconda, exposed to R via `reticulate`
- SQLite CLI + libraries
- Automatically starts:
  - Plumber API (port `8000`)
  - DIMSpec Shiny apps:
    - msMatch (port `7000`)
    - table_explorer (port `7001`)
    - dimspec-qc (port `7002`)
    - (optional default app at port `3838`)
- Works on Linux, macOS, Windows (with Docker)
- No local R/Python setup needed

---

## 📁 Project Structure

```

.
├── Dockerfile                  # Main image build instructions
├── docker/
│   └── install\_packages.R      # Pre-install required R packages
├── docker-compose.yml          # Docker Compose setup (multi-port)
├── build\_and\_run.sh            # Build & run helper script
├── entry.sh                    # Startup script (Shiny apps + API)
├── data/                       # Persistent SQLite DB mount
└── env\_glob.txt                # DIMSpec global config (readonly)

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

### 3. Access the interfaces (replace IP if on a remote server)

* **msMatch Shiny app**: [http://localhost:7000](http://localhost:7000)
* **table\_explorer Shiny app**: [http://localhost:7001](http://localhost:7001)
* **dimspec-qc Shiny app**: [http://localhost:7002](http://localhost:7002)
* **Main Shiny app**: [http://localhost:3838](http://localhost:3838)
* **Plumber API (Swagger UI)**: [http://localhost:8000/\_\_docs](http://localhost:8000/__docs)\_\_

---

## 🛠 Custom Configuration

If you want to use your own `env_glob.txt` configuration:

```bash
docker run -d --name dimspec \
  -p 3838:3838 -p 8000:8000 \
  -p 7000:7000 -p 7001:7001 -p 7002:7002 \
  -v $(pwd)/env_glob.txt:/opt/DIMSpec/config/env_glob.txt:ro \
  -v $(pwd)/data:/opt/DIMSpec/db \
  nist/dimspec:latest
```

You can mount other files (e.g., custom R scripts) the same way or bake them into a derived image.

---

## 🐳 Using Docker Compose

If you prefer `docker-compose`, launch with:

```bash
docker compose up -d
```

Make sure your `docker-compose.yml` contains:

```yaml
version: "3.9"
services:
  dimspec:
    build: .
    container_name: dimspec
    ports:
      - "3838:3838"
      - "7000:7000"
      - "7001:7001"
      - "7002:7002"
      - "8000:8000"
    volumes:
      - ./data:/opt/DIMSpec/db
      - ./env_glob.txt:/opt/DIMSpec/config/env_glob.txt:ro
    restart: unless-stopped
```

---

## 🧪 Troubleshooting

* **First start takes longer**: DIMSpec may cache packages or run compliance scripts
* **Interactive R console**: Run `docker exec -it dimspec R`
* **Conda / RDKit issues**: Ensure `/opt/conda/bin` is first in `PATH` (image does this)
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
* Multi-Shiny and API interface access across defined ports
* Identical workflow to the official DIMSpec Quick-Guide


