# 🎉 Project G: Edge Lab Gateway – Data Sync to Cloud

## 🚀 Goal

Simulate a lightweight edge device setup that **monitors a local folder** for changes (e.g., new scientific data from sensors or lab instruments) and **syncs those files to a cloud bucket** automatically and securely.

This mirrors workflows seen in field biology, agricultural R\&D, or portable genomics tools, where syncing data from lab benches or field stations to centralized storage is critical.

---

## 🧰 Concepts & Tools

| Area            | Tools / Concepts                      |
| --------------- | ------------------------------------- |
| File Monitoring | `inotifywait`, `entr`, `fswatch`      |
| Sync Mechanism  | `rsync`, `rclone`, `scp`, or `sftp`   |
| Scheduling      | `cron`, `systemd timers`              |
| Security        | SSH keys, `rclone` encryption, hashes |
| Cloud Targets   | GCS, AWS S3, Azure Blob, FTP/SFTP     |

---

## 📂 Directory Structure

```plaintext
Project_G_EdgeLab_Sync/
├── sync-to-cloud.sh        # Handles the sync job (via rsync or rclone)
├── watcher.sh              # Watches the folder for changes using inotify
├── crontab.txt             # Example cron job to schedule periodic sync
├── cloud-config/
│   └── rclone.conf         # Config file for rclone with cloud credentials
├── logs/
│   └── sync.log            # Output logs from watcher or cron jobs
└── README.md               # Project documentation
```

---

## ⚙️ How It Works

### 1. `watcher.sh`: Monitor for File Changes

```bash
#!/bin/bash

WATCH_DIR="/data"
LOG_FILE="./logs/sync.log"

inotifywait -m -e close_write --format '%w%f' "$WATCH_DIR" | while read FILE
  do
    echo "$(date) Detected new/changed file: $FILE" >> "$LOG_FILE"
    ./sync-to-cloud.sh "$FILE" >> "$LOG_FILE" 2>&1
  done
```

### 2. `sync-to-cloud.sh`: Cloud Sync Script

```bash
#!/bin/bash

FILE="$1"
DEST="remote:lab-data"  # Must match your rclone remote config
LOG="./logs/sync.log"

echo "$(date) Syncing $FILE to $DEST"

rclone copy "$FILE" "$DEST" --log-file="$LOG" --log-level INFO
```

> ✅ You can also replace `rclone` with `rsync` or `scp` if syncing to a remote server instead of cloud object storage.

---

## 🕒 Fallback Cron Job (Optional)

Add this to your crontab for periodic full syncs (e.g., every 6 hours):

```cron
0 */6 * * * /usr/bin/rclone sync /data remote:lab-data >> ~/sync-cron.log 2>&1
```

Save your crontab with:

```bash
crontab crontab.txt
```

---

## 🔐 Security Best Practices

* Use SSH key-based auth if using `scp` or `rsync` to remote server.
* Use `rclone config` to encrypt cloud credentials and avoid putting them in plain text.
* Validate file integrity after sync with `md5sum` or `shasum` comparison.

---

## 🔍 Real-World Use Cases

| Context                  | Use Case Example                                         |
| ------------------------ | -------------------------------------------------------- |
| AgTech Edge Devices      | Push crop sensor CSVs to a central server                |
| Genomics & Bio Labs      | Upload sequencing output from portable MinION machines   |
| Environmental Monitoring | Sync sensor logs from forest or marine data buoys        |
| Remote Field Stations    | Archive phenomic/phenotypic data for analysis back at HQ |

---

## 🔗 References

* [rclone documentation](https://rclone.org/docs/)
* [inotifywait](https://linux.die.net/man/1/inotifywait)
* [Setting up cron jobs](https://opensource.com/article/19/11/cron-linux)
* [Secure syncing with rsync over SSH](https://www.tecmint.com/rsync-local-remote-file-synchronization-commands/)
* [Use cases: Edge Data Collection in Bioinformatics](https://www.nature.com/articles/s41587-020-0500-1)

---

## ✅ Future Enhancements

* Web dashboard to show sync status
* Push notification alerts for failures
* Data compression before upload
* Use of hashed folders to avoid file collisions
