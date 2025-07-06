# AutoBackup Script (with Cron) on Ubuntu EC2

This project automates the backup of a folder on an Ubuntu EC2 instance using a shell script and schedules it using `cron`.

---

## Project Overview

You will:
- Create a folder containing dummy files on an EC2 instance to simulate data
- Write a shell script to compress the folder into a `.tar.gz` file
- Store the backup in a separate directory
- Schedule the script using `cron` so it runs automatically every day (or every few minutes for testing)

---

## Prerequisites

- Ubuntu EC2 instance running
- SSH access to the instance
- Basic knowledge of terminal and Linux commands

---

## Step-by-Step Instructions

### ✅ 1. Clone the Repo
```bash
git clone https://github.com/Shravani3001/EC2_backup_project.git
cd EC2_backup_project
```

### ✅ 2. Generate SSH Key Pair
```bash
ssh-keygen -t rsa -b 4096 -f backup_key
```

This generates backup_key and backup_key.pub

### ✅ 3. Deploy Infrastructure
```bash
terraform init
terraform apply
```

### ✅ 4. Connect to Your EC2 Instance
```bash
ssh -i ./backup_key ubuntu@<ec2-public-ip>
```

### ✅ 5. Create Dummy Data
```bash
mkdir -p /home/ubuntu/mydata
cd /home/ubuntu/mydata
echo "Sample file 1" > file1.txt
echo "Sample file 2" > file2.txt
```

### ✅ 6. Write the Backup Script
```bash
nano /home/ubuntu/backup.sh
```
Paste the following script:

```bash
#!/bin/bash

# Variables
SOURCE_DIR="/home/ubuntu/mydata"
BACKUP_DIR="/home/ubuntu/backups"
DATE=$(date +%F_%T)
BACKUP_FILE="$BACKUP_DIR/mydata_backup_$DATE.tar.gz"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create the backup archive
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

echo "Backup completed at $DATE"
```

**Save and exit:**

Ctrl + O, then Enter

Ctrl + X

### ✅ 7. Make the Script Executable
```bash
chmod +x /home/ubuntu/backup.sh
```
### ✅ 8. Run the Script Manually to Test
```bash
/home/ubuntu/backup.sh
```

Check the backup file:
```bash
ls /home/ubuntu/backups
```

You should see:
**mydata_backup_2025-07-06_18:01:50.tar.gz**

### ✅ 9. Schedule the Script with Cron
```bash
crontab -e
```
If you get this:
```bash
Select an editor.  To change later, run 'select-editor'.
  1. /bin/nano        <---- easiest
  2. /usr/bin/vim.basic
  3. /usr/bin/vim.tiny
  4. /bin/ed
Choose 1-4 [1]: 
```

Choose 1 for Nano editor.

Then add this line for daily backups at midnight:
```bash
0 0 * * * /home/ubuntu/backup.sh
```
**Or for testing every 2 minutes:**

```bash
*/2 * * * * /home/ubuntu/backup.sh
```

Then:

Press Ctrl + O, then Enter to save

Press Ctrl + X to exit

### ✅ 10. Confirm It’s Set Up:

Run:
```bash
crontab -l
```

You should see your cron job listed.

## Author

Shravani K

DevOps Learner

LinkedIn: www.linkedin.com/in/shravani-k-25953828a


