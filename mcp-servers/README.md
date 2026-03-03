# MCP Servers Collection

Collection of MCP servers used for homelab operations and tooling workflows.

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
cd /Volumes/Data/_ai/_mcp/mcp_stuff/mcp-servers/mcp-servers
npm install
```

2. For Proxmox MCP (Python), bootstrap its local venv:
```bash
cd /Volumes/Data/_ai/_mcp/mcp_stuff/proxmox-mcp-server
./bootstrap.sh
cp .env.example .env
# then set PROXMOX_HOST / PROXMOX_USER / PROXMOX_TOKEN
```

3. Start Proxmox MCP via wrapper (used by Codex config):
```bash
cd /Volumes/Data/_ai/_mcp/mcp_stuff/mcp-servers
./wrappers/proxmox.sh
```

## Client Integration

### Codex (`~/.codex/config.toml`)

```toml
[mcp_servers.proxmox]
command = "bash"
args = ["/Volumes/Data/_ai/_mcp/mcp_stuff/mcp-servers/wrappers/proxmox.sh"]
```

### Claude (`~/.claude.json`)

The current setup uses a direct Python entrypoint to the same Proxmox MCP code/config:

- command: `/Volumes/Data/_ai/_mcp/mcp_stuff/proxmox-mcp-server/venv/bin/python`
- args include:
  - `.../proxmox-mcp-server/run_server.py`
  - `run`
  - `.../proxmox-mcp-server/proxmox_mcp_config.json`

## Notes

- Prefer API token auth for Proxmox (`PROXMOX_TOKEN`) over password auth.
- `proxmox-mcp-server/` currently has a large local change set in `venv/`; avoid committing virtualenv artifacts to keep diffs and reviews manageable.
- See `proxmox-mcp-server/README.md` for full Proxmox capabilities, safety controls, and maintenance/audit tooling.
