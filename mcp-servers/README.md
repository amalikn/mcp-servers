# MCP Servers Collection

Collection of MCP servers used for homelab operations and tooling workflows.

## Path Placeholders

- `<MCP_STUFF_ROOT>`: local checkout root for the parent repo (example: `/Volumes/Data/_ai/_mcp/mcp_stuff`)
- `<MCP_DATA_ROOT>`: persistent runtime data root (example: `/Volumes/Data/_ai/mcp-data`)

## Available Servers

- `network-mcp-server/` - network and connectivity operations
- `proxmox-mcp-server/` - Proxmox VE infrastructure management
- `truenas-mcp-server/` - TrueNAS operations
- `wikijs-mcp-server/` - Wiki.js integration
- `code-linter-mcp-server/` - code linting and quality checks
- `directory-polling-server/` - filesystem polling and change detection

## Quick Setup

1. Install top-level Node dependencies (for Node-based servers):
```bash
cd <MCP_STUFF_ROOT>/mcp-servers/mcp-servers
npm install
```

2. For Proxmox MCP (Python), bootstrap its local venv:
```bash
cd <MCP_STUFF_ROOT>/proxmox-mcp-server
./bootstrap.sh
cp .env.example .env
# then set PROXMOX_HOST / PROXMOX_USER / PROXMOX_TOKEN
```

3. Start Proxmox MCP via wrapper (used by Codex config):
```bash
cd <MCP_STUFF_ROOT>/mcp-servers
./wrappers/proxmox.sh
```

## Client Integration

### Codex (`~/.codex/config.toml`)

```toml
[mcp_servers.proxmox]
command = "bash"
args = ["<MCP_STUFF_ROOT>/mcp-servers/wrappers/proxmox.sh"]
```

### Claude (`~/.claude.json`)

The current setup uses a direct Python entrypoint to the same Proxmox MCP code/config:

- command: `<MCP_STUFF_ROOT>/proxmox-mcp-server/venv/bin/python`
- args include:
  - `.../proxmox-mcp-server/run_server.py`
  - `run`
  - `.../proxmox-mcp-server/proxmox_mcp_config.json`

## Notes

- Prefer API token auth for Proxmox (`PROXMOX_TOKEN`) over password auth.
- `proxmox-mcp-server/` currently has a large local change set in `venv/`; avoid committing virtualenv artifacts to keep diffs and reviews manageable.
- See `proxmox-mcp-server/README.md` for full Proxmox capabilities, safety controls, and maintenance/audit tooling.
