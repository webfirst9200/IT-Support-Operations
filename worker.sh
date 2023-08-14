### CONFIGURE A KUBERNETES CLUSTER WITH KUBEADM

## BOTH MASTER AND WORKER NODES

## INSTALL PACKAGES

# 1. Create the configuration file for containerd:
# (Load Kernel Modules and System Configuration)

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

# 2. Load the modules:

sudo modprobe overlay

sudo modprobe br_netfilter

# 3. Set the system configurations for Kubernetes networking:
# (System Networking and Firewall Configurations)

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# 4. Apply the new settings:
# (Apply system-wide sysctl settings)

sudo sysctl --system

# 5. Install Containerd:

sudo apt-get update && sudo apt-get install -y containerd

# 6. Create the default configuration file for containerd:
# (Configure Containerd)

sudo mkdir -p /etc/containerd

# 7. Generate the default containerd configuration, and save it to the newly created default file:

sudo containerd config default | sudo tee /etc/containerd/config.toml

# 8. Restart Containerd to make sure the new configuration file is used:

sudo systemctl restart containerd

# 9. Verify that containerd is running:

sudo systemctl status containerd

# 10. Disable Swap:

sudo swapoff -a

# OPTIONAL: Comments out any lines in /etc/fstab that refer to swap partitions,
# effectively preventing them from being mounted on system startup.

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# 11. Install the dependency packages:

sudo apt-get update && sudo apt-get install -y apt-transport-https curl

# 12. Download and add the GPG key:

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# 13. Add Kubernetes to the repository list:

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# 14. Update the packages listings:

sudo apt-get update

# 15. Install Kubernetes packages:

sudo apt-get install -y kubelet=1.27.0-00 kubeadm=1.27.0-00 kubectl=1.27.0-00

# 16. Turn off automatic updates:

sudo apt-mark hold kubelet kubeadm kubectl

###  ONLY WORKER NODES

# 1. Paste the full 'kubeadm join" command on the worker nodes. Use <sudo> to run as root:

# sudo kubeadm join...

### View the Cluster Status:

# kubectl get nodes  
