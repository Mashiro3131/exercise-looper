# Backups

Currently scheduled automatically.

## Why

-   Provides a reliable recovery option independent of snapshots.
-   Ensures VM data can be restored in case of hardware failure,
    corruption, or accidental deletion.
-   Serves as the primary disaster recovery strategy (unlike snapshots,
    which are temporary restore points).
-   Backups can be moved off-node or off-site for long-term protection.

## How

### Storage Setup

Before configuring the scheduled backup job, the local backup storage directory was created and secured manually:  

```bash
mkdir -p /var/lib/vz/backups
chown root:root /var/lib/vz/backups
chmod 700 /var/lib/vz/backups
```

This directory was then defined in Proxmox as local-backups and used as the storage target for scheduled backups.

-   Backups are scheduled via the Proxmox web UI under **Datacenter →
    Backup**.
-   The current configuration (from your screenshot):
    -   **Node:** `pve`
    -   **Schedule:** Every **Sunday at 01:00**
    -   **Storage:** `local-backups`
    -   **Retention:** `keep-last=2` (keeps the 2 most recent backups)
    -   **Selection:** VM **100**
-   Process:
    -   At the scheduled time, Proxmox automatically creates a backup of
        the selected VM.
    -   Backups are stored in the `local-backups` storage.
    -   Older backups beyond the last 2 are automatically removed.
-   To run manually:
    -   Go to the VM → **Backup** tab → Click **Backup now** → Choose
        storage and mode (snapshot, suspend, stop) → Confirm.
-   To restore:
    -   Select the backup in **Datacenter → Storage → local-backups →
        Content** or in the VM's **Backup** tab.
    -   Click **Restore** and confirm the target.
