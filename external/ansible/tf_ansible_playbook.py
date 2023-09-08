import sys
import os
import subprocess

def runPlaybook(host, playbook):
    if os.path.isfile(playbook):
        print(f"ansible-playbook -l {host} {playbook}")
        subprocess.call(["ansible-playbook", "-l", host, playbook])
    else:
        print(f"{playbook} not found!")
        
        
if len(sys.argv) < 3 :
    sys.exit(1)
host = sys.argv[1]
playbooks = sys.argv[2:]
for playbook in playbooks:
    runPlaybook(host, playbook)