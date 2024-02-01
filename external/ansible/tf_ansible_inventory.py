import re
import sys

if len(sys.argv) < 5 or not sys.argv[2] in ["rm", "add"]:
    sys.exit(1)

inventory = {}
new_inventory = {}
tag = ""
ansible_hosts = sys.argv[1]

with open(ansible_hosts) as f:
    for line in f.readlines():
        if re.match("\[\S+\]", line):
            tag = line.strip()[1:-1]
            inventory[tag] = set()
        elif tag != "" and line.strip() != "":
            inventory[tag].add(line.strip())

hostname = sys.argv[3]
ip = sys.argv[4]

if sys.argv[2] == "add":

    if "servers" in inventory:
        inventory["servers"].add(hostname + " ansible_host=" + ip)
    if len(sys.argv) > 5:
        for new_tag in sys.argv[5:]:
            if new_tag in inventory:
                inventory[new_tag].add(hostname + " ansible_host=" + ip)
            else:
                inventory[new_tag] = [hostname + " ansible_host=" + ip]
    new_inventory = inventory
else:
    for tag, hosts in inventory.items():
        new_hosts = set()
        for host in hosts:
            if not (host.split()[0] == hostname and host.split()[1] == "ansible_host=" + ip):
                new_hosts.add(host)
        if not len(new_hosts) == 0 or tag == "servers":
            new_inventory[tag] = new_hosts

with open(ansible_hosts, "w") as f:
    sys.stdout = f
    for tag, hosts in new_inventory.items():
        print("[" + tag + "]")
        for host in hosts:
            print(host)
        print()
