# 📡 Static IP Configuration for k3s Homelab (Proxmox + Debian 12)

This guide documents the complete, tested process used to configure **persistent static IP addresses** on all k3s cluster nodes (`control-plane`, `worker-1`, `worker-2`) running Debian 12 in Proxmox VMs.

---

## ✅ Goals

- Disable DHCP and ensure static IPs persist across reboots
- Avoid conflicts with `NetworkManager`, `ifupdown`, and Proxmox defaults
- Maintain full Kubernetes + CNI compatibility (Flannel, cni0, veth, etc.)
- Avoid SSH session loss during migration

---

## 🧱 Example IP Plan

| Node           | Role           | Static IP        |
|----------------|----------------|------------------|
| control-plane  | Control Plane  | `192.168.1.80`   |
| worker-1       | Worker         | `192.168.1.90`   |
| worker-2       | Worker         | `192.168.1.91`   |

---

## 🛠 Step-by-Step: Static IP Configuration (Per Node)

### 1. ✅ Install and Enable NetworkManager

```bash
apt update && apt install -y network-manager
systemctl enable NetworkManager
systemctl start NetworkManager
```

## 2. 🧼 Disable legacy /etc/network/interfaces DHCP

Edit the file:
```bash
nano /etc/network/interfaces

Comment out or delete:

# allow-hotplug ens18
# iface ens18 inet dhcp
# iface ens18 inet6 auto

Leave only the loopback:

auto lo
iface lo inet loopback
```
## 3. ✅ Allow NetworkManager to manage interfaces

Edit:
```bash
nano /etc/NetworkManager/NetworkManager.conf

Ensure this section exists:

[ifupdown]
managed=true
```
Save and exit.
## 4. 🔄 Restart networking services
```bash
systemctl restart networking
systemctl restart NetworkManager
```
## 5. ⚙️ Create a static connection profile
```bash
For control-plane:

nmcli con add type ethernet con-name static-controlplane ifname ens18 autoconnect yes ipv4.method manual \
ipv4.addresses 192.168.1.80/24 ipv4.gateway 192.168.1.1 ipv4.dns "1.1.1.1 8.8.8.8"

For worker-1:

nmcli con add type ethernet con-name static-worker1 ifname ens18 autoconnect yes ipv4.method manual \
ipv4.addresses 192.168.1.90/24 ipv4.gateway 192.168.1.1 ipv4.dns "1.1.1.1 8.8.8.8"

For worker-2:

nmcli con add type ethernet con-name static-worker2 ifname ens18 autoconnect yes ipv4.method manual \
ipv4.addresses 192.168.1.91/24 ipv4.gateway 192.168.1.1 ipv4.dns "1.1.1.1 8.8.8.8"
```
## 6. ✅ Activate the static connection
```bash
nmcli con up static-controlplane   # or static-worker1 / static-worker2
```
## 7. 🧹 Delete unused/rogue connections (safe to run once static is working)
```bash
nmcli con delete "Wired connection 1"
nmcli con delete "Wired connection 2"
nmcli con delete "Wired connection 3"

Optional cleanup:

nmcli con delete $(nmcli con show | grep veth | awk '{print $1}')
```
## 8. 🔁 Reboot and confirm
```bash
reboot

After reboot:

ip a
nmcli con show --active
```
✅ Confirm the correct static IP is applied
✅ Only the custom profile (static-*) is active
✅ No DHCP lease present
🧪 Optional: Validate from control-plane
```bash
kubectl get nodes -o wide

You should see:
Node	IP	Status
control-plane	192.168.1.80	Ready
worker-1	192.168.1.90	Ready
worker-2	192.168.1.91	Ready
```

🧠 Notes

    Do not create static configs in /etc/network/interfaces — use nmcli

    veth*, flannel.1, and cni0 are created dynamically by Kubernetes/Flannel

    Static IPs must be outside your DHCP pool to avoid collisions