### NOTES
# 1. Load Kernel Modules and System Configuration:

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay

sudo modprobe br_netfilter

# System Networking and Firewall Configurations
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system  # Apply System-wide sysctl settings

### 2. Install Containerd:

sudo apt-get update && sudo apt-get install -y containerd

### 3. Configure Containerd:

sudo mkdir -p /etc/containerd

sudo containerd config default | sudo tee /etc/containerd/config.toml

### 4. Restart Containerd:

sudo systemctl restart containerd

sudo systemctl status containerd --no-pager

### 5. Disable Swap:

sudo swapoff -a

# OPTIONAL: Comments out any lines in /etc/fstab that refer to swap partitions,
# effectively preventing them from being mounted on system startup. 

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

### 6. Add Kubernetes Repository:

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-get update && sudo apt-get install -y apt-transport-https curl

### 7. Install Kubernetes Components:

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update

sudo apt-get install -y kubelet=1.24.0-00 kubeadm=1.24.0-00 kubectl=1.24.0-00

sudo apt-mark hold kubelet kubeadm kubectl

### OPTIONAL: Configure Shell Environment:

echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'alias c=clear' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc
sed -i '1s/^/force_color_prompt=yes\n/' ~/.bashrc

cat > ~/.vimrc << EOF
set ts=2 sts=2 sw=2 et nu ai cuc cul 
EOF

