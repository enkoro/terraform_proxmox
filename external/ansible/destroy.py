import re
import sys
import argparse
import pathlib
import subprocess


def readInventory(hosts_path):
    inventory = {}
    with open(hosts_path) as f:
        for line in f.readlines():
            if re.match("\[\S+\]", line):
                tag = line.strip()[1:-1]
                inventory[tag] = set()
            elif tag != "" and line.strip() != "":
                inventory[tag].add(line.strip())
    return inventory


def writeInventory(hosts_path, inventory):
    with open(hosts_path, "w") as f:
        sys.stdout = f
        for tag, hosts in inventory.items():
            print("[" + tag + "]")
            for host in hosts:
                print(host)
            print()


parser = argparse.ArgumentParser()
parser.add_argument('-H', '--ansible_hosts', type=pathlib.Path, nargs=1, required=True,
                    help='nsible hosts file.')
parser.add_argument('-N', '--hostname', type=str, nargs=1, required=True,
                    help='Hostname to remove from inventory.')
parser.add_argument('-I', '--ip', type=str, nargs=1, required=True,
                    help='IP to remove from known_hosts.')

args = parser.parse_args()

new_inventory = {}
hosts_path = args.ansible_hosts[0]
hostname = args.hostname[0]
ip = args.ip[0]

try:
    inventory = readInventory(hosts_path)
    for tag, hosts in inventory.items():
        new_hosts = set()
        for host in hosts:
            if not (host.split()[0] == hostname):
                new_hosts.add(host)
        if not len(new_hosts) == 0 or tag == "servers":
            new_inventory[tag] = new_hosts
    writeInventory(hosts_path, new_inventory)
except Exception as e:
    print(e)

# Remove host entries from known_hosts
subprocess.run(["ssh-keygen", "-R", ip])
