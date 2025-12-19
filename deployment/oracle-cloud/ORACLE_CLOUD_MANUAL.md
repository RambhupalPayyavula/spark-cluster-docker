# Deploying Spark Cluster on Oracle Cloud Free Tier

This guide walks you through setting up your **Always Free** ARM server on Oracle Cloud and deploying this Spark cluster to it.

## 1. Create the Instance (VM)

1.  Log in to your **Oracle Cloud Console**.
2.  Go to **Compute** -> **Instances** -> **Create Instance**.
3.  **Name**: `spark-cluster` (or your choice).
4.  **Placement**: choose any availability domain.
5.  **Image and Shape**:
    *   **Image**: Click "Change Image" -> Select **Canonical Ubuntu 22.04** (Recommended) or Oracle Linux 8/9.
    *   **Shape**: Click "Change Shape".
        *   Select **Ampere** (ARM) series.
        *   Check **VM.Standard.A1.Flex**.
        *   **OCPUs**: Set to `4`.
        *   **Memory (GB)**: Set to `24`.
    *   *Note: If it says "Out of capacity", try a different Availability Domain.*
6.  **Networking**:
    *   Create new VCN: `spark-vcn`.
    *   Create new public subnet: `spark-subnet`.
    *   **IMPORTANT**: Assign a Public IPv4 address.
7.  **Add SSH Keys**:
    *   "Save Private Key" (Keep this safe! You need it to log in).
8.  Click **Create**.

---

## 2. Configure Firewall (Security Lists)

By default, Oracle blocks all ports except SSH (22). You need to open ports for Jupyter, Spark, HDFS, etc.

1.  Click on your new instance name.
2.  Click on the **Subnet** link (e.g., `subnet-2023...`).
3.  Click on the **Security List** (e.g., `Default Security List for...`).
4.  Click **Add Ingress Rules**.
5.  **Source CIDR**: `0.0.0.0/0` (Allows access from anywhere) OR your specific IP address for security.
6.  **Destination Port Range**: Enter these ports separated by commas or add multiple rules:
    ```
    8888, 8080, 8081, 8082, 9870, 8088, 16010, 5432
    ```
    *   `8888`: JupyterLab
    *   `8080`: Spark Master
    *   `8081-8082`: Spark Workers
    *   `9870`: HDFS Namenode
    *   `8088`: YARN ResourceManager
    *   `16010`: HBase Master
    *   `5432`: Postgres
7.  Click **Add Ingress Rules**.

---

## 3. Connect and Deploy

1.  **Get your Public IP** from the Instance details page.
2.  **SSH into the server**:
    ```bash
    # Move key to a secure place and fix permissions
    chmod 400 keyfile.key

    # Login (username is 'ubuntu' for Ubuntu image, or 'opc' for Oracle Linux)
    ssh -i keyfile.key ubuntu@<YOUR_PUBLIC_IP>
    ```

3.  **Run the Setup Script**:
    Once logged in, run these commands to download and execute the setup script.

    *Option A: Clone your repo (if you pushed it to GitHub)*
    ```bash
    git clone <YOUR_REPO_URL>
    cd spark-cluster-docker/deployment/oracle-cloud
    chmod +x setup_oracle_vm.sh
    ./setup_oracle_vm.sh
    ```

    *Option B: Copy-paste the script (if you haven't pushed yet)*
    ```bash
    nano setup.sh
    # Paste the content of 'setup_oracle_vm.sh' here
    # Save (Ctrl+O) and Exit (Ctrl+X)
    chmod +x setup.sh
    ./setup.sh
    ```

4.  **Wait for Build**: The script will install Docker, pull images, and start the cluster. This takes ~5-10 minutes.

---

## 4. Access Your Cluster

Open your browser and enter:

*   **JupyterLab**: `http://<YOUR_PUBLIC_IP>:8888`
*   **Spark UI**: `http://<YOUR_PUBLIC_IP>:8080`
*   **HDFS**: `http://<YOUR_PUBLIC_IP>:9870`

Success! You now have a powerful 24GB RAM Spark cluster running for free.
