# Automated Folder Backup on Ubuntu EC2 using Bash + Cron + Terraform

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

## Tools & Services Used

| Tool/Service    | Purpose                                     |
|----------------|---------------------------------------------|
| AWS EC2         | To host the Ubuntu instance                 |
| Terraform       | To provision the EC2 instance               |
| Bash            | To write the backup automation script       |
| Cron            | To schedule and run the backup periodically |
| SSH             | To securely access the instance             |

---

## Features

- ✅ Automatic backups using cron
- ✅ Timestamped compressed backup files (`.tar.gz`)
- ✅ Easy to configure and customize
- ✅ One-click infrastructure deployment using Terraform
- ✅ Clean and reusable Bash script

---

## How It Works

The automation works in three main steps:

**1. Shell Script**: A backup script compresses the contents of a specified directory using `tar` and stores it with a timestamp in a separate backup directory.

**2. Cron Job**: The script is scheduled using `cron` to run automatically at regular intervals (daily or every few minutes).

**3. Persistence**: All backup files are stored on the EC2 instance under a dedicated folder for easy access and recovery.

---

## Architecture Diagram

<img width="618" height="513" alt="ec2-backup-output" src="https://github.com/user-attachments/assets/ca709a7c-102f-4239-af11-036834a63b51" />

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
0 0 * * * /home/ubuntu/backup.sh >> /home/ubuntu/backup.log 2>&1
```
**Or for testing every 2 minutes:**

```bash
*/2 * * * * /home/ubuntu/backup.sh >> /home/ubuntu/backup.log 2>&1
```
**What this does:**
```bash
- >> /home/ubuntu/cron_backup.log appends output to a log file
- 2>&1 captures any errors too
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

Wait 2–4 minutes

Let cron run the job once or twice.

**Check the Log File**
```bash
cat /home/ubuntu/cron_backup.log
```

You should see:
```bash
Backup completed at 2025-07-14_14:47:50
...
```
---

## Output 
<img width="914" height="536" alt="cron-job-output" src="https://github.com/user-attachments/assets/8a33e1b1-75d5-411a-a42d-935e89d56baf" />

---

## About Me

I'm Shravani, a self-taught and project-driven DevOps engineer passionate about building scalable infrastructure and automating complex workflows.

I love solving real-world problems with tools like Terraform, Ansible, Docker, Jenkins, and AWS — and I’m always learning something new to sharpen my edge in DevOps.

**Connect with me:**

[LinkedIn](https://www.linkedin.com/in/shravani3001) 

[GitHub](https://github.com/Shravani3001)

