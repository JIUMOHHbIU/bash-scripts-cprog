#!/usr/bin/python3.10

import subprocess
import pprint

scripts_dir="__tmp_scripts_to_copy"
repo_link = 'git@github.com:JIUMOHHbIU/bash-scripts-cprog.git'
id_pattern = "@id=.*$"

def check_output(args):
	return subprocess.check_output([*args]).decode('utf-8').strip().split('\n')

def grep(pattern, path):
	return subprocess.run(['grep', '-o', pattern, path], capture_output=True).stdout.decode('utf-8').strip()

def update_repo():
	update_repo_script_sh = f'if [ -d ./"${scripts_dir}" ]; then git -C ./"${scripts_dir}" pull; else git clone {repo_link} "${scripts_dir}"; fi'
	subprocess.run(update_repo_script_sh, shell=True, text=True)

# update_repo()

installed_scripts = dict([ (path, grep(id_pattern, path)) for path in check_output(['find', '.', '-name', '*.sh', '!', '-path', f'*{scripts_dir}*']) ])
# pprint.pprint(installed_scripts, width=120)

remote_scripts = dict([ (path, grep(id_pattern, path)) for path in check_output(['find', f'./{scripts_dir}', '-name', '*.sh']) ])
# pprint.pprint(remote_scripts, width=120)

installed_ids = set(installed_scripts.values())
remote_ids = set(remote_scripts.values())

for path, id in installed_scripts.items():
	if not id:
		print(f'! installed without id: {path}')
	else:
		if id in remote_ids:
			print(f'found version of {path} in repo({id})')
		else:
			print(f'! no version of {path} in repo({id})')

# pprint.pprint(set(installed_scripts.values()) ^ set(remote_scripts.values()), width=120)
