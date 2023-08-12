import sys
import os
import subprocess


if len(sys.argv) < 3 :
    sys.exit(1)
    
ansible_dir = "/root/ansible/"
host = sys.argv[1]

tags = sys.argv[2:]
for tag in tags:
    playbook = ansible_dir + tag + ".yml"
    if os.path.isfile(playbook):
        print(f"ansible-playbook -l {host} {playbook}")
        subprocess.call(["ansible-playbook", "-l", host, playbook])