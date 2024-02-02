import re
import sys
import argparse
import pathlib
import subprocess
import os


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


def runPlaybook(host, playbook):
    if os.path.isfile(playbook):
        print(f"ansible-playbook -l {host} {playbook}")
        subprocess.call(["ansible-playbook", "-l", host, playbook])
    else:
        print(f"{playbook} not found!")


parser = argparse.ArgumentParser()
parser.add_argument('-H', '--ansible_hosts', type=pathlib.Path, nargs=1, required=True,
                    help='Ansible hosts file.')
parser.add_argument('-K', '--known_hosts', type=pathlib.Path, nargs=1, required=True,
                    help='Known hosts file.')
parser.add_argument('-N', '--hostname', type=str, nargs=1, required=True,
                    help='Hostname to add to inventory.')
parser.add_argument('-T', '--tags', nargs='+', required=True,
                    help='IP to add to known_hosts.')
parser.add_argument('-P', '--playbooks', nargs='*', required=False,
                    help='IP to add to known_hosts.')

args = parser.parse_args()

hosts_path = args.ansible_hosts[0]
hostname = args.hostname[0]
ip = args.tags[0]
known_hosts_path = args.known_hosts[0]

try:
    inventory = readInventory(hosts_path)
    if "servers" in inventory:
        inventory["servers"].add(hostname + " ansible_host=" + ip)
    if len(args.tags) > 1:
        for new_tag in args.tags[1:]:
            if new_tag in inventory:
                inventory[new_tag].add(hostname + " ansible_host=" + ip)
            else:
                inventory[new_tag] = [hostname + " ansible_host=" + ip]
    writeInventory(hosts_path, inventory)
except Exception as e:
    print(e)

try:
    with open(known_hosts_path, "a") as f:
        subprocess.run(["ssh-keyscan", "-t", "rsa", ip], stdout=f)
    if args.playbooks:
        for playbook in args.playbooks:
            runPlaybook(hostname, playbook)
except Exception as e:
    print(e)
