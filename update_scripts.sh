#!/bin/bash

# @id=f4aee6de86c0b4d1ce7aaa0be89a9280

python_script="\
import subprocess
import pprint
import unicodedata


def beautify(s):
	return s.decode('utf-8').strip()


def run_sp(args):
	sp = subprocess.run([*args], capture_output=True)
	return { 'rc': sp.returncode, 'stdout': beautify(sp.stdout), 'stderr': beautify(sp.stderr) }


def check_output(args):
	return run_sp(args)['stdout'].split('\n')


def grep(pattern, path):
	return run_sp(['grep', '-o', pattern, path])['stdout']


def update_repo(repo_link, scripts_dir):
	update_repo_script_sh = f'if [ -d ./{scripts_dir} ]; then cd {scripts_dir}; git pull; else git clone {repo_link} {scripts_dir}; fi'
	subprocess.run(update_repo_script_sh, shell=True, text=True)


def get_aligned_string(string, width):
    string = f'{string:{width}}'
    string = str(bytes(string, 'utf-8')[0:width], encoding='utf-8', errors='backslashreplace')
    new_width = len(string) + int((width - len(string)) / 2)

    if new_width != 0:
        string = f'{str(string):{new_width}}'
    return string


scripts_dir=\"__tmp_scripts_to_copy\"
repo_link = 'git@github.com:JIUMOHHbIU/bash-scripts-cprog.git'

id_pattern = \"^# @id=.*$\"
const_pattern = \"^# @const$\"

update_repo(repo_link, scripts_dir)

installed_paths = check_output(['find', '.', '-name', '*.sh', '!', '-path', f'*{scripts_dir}*'])
installed_p2i = dict([(path, grep(id_pattern, path)) for path in installed_paths])
installed_i2p = {v: k for k, v in installed_p2i.items()}

installed_is_const_p2i = dict([(path, grep(const_pattern, path)) for path in installed_paths])

remote_paths = check_output(['find', f'./{scripts_dir}', '-name', '*.sh'])
remote_p2i = dict([(path, grep(id_pattern, path)) for path in remote_paths])
remote_i2p = {v: k for k, v in remote_p2i.items()}

output_width = 100
for path, id in installed_p2i.items():
	short_id = id[-6:]
	short_path = path.split('/')[-1]
	possible_remote_path = './' + scripts_dir + '/'.join(path.split('/')[1:])
	if not installed_is_const_p2i[path]:
		if not id:
			print(f'{get_aligned_string(str(f\"! var: deleting {short_path} without id\"), output_width)}: ', end='')
			rc, __out, __err = run_sp(['rm', path]).values()
			print('success' if rc == 0 else f'! failed: {__err}')
		else:
			if id in remote_i2p.keys():
				print(f'{get_aligned_string(str(f\"var: updating {short_path} from repo(id=..{short_id})\"), output_width)}: ', end='')
				rc, __out, __err = run_sp(['cp', remote_i2p[id], path]).values()
				print('success' if rc == 0 else f'! failed: {__err}')
			else:
				print(f'{get_aligned_string(str(f\"! var: deleting {short_path} wrong id(id=..{short_id})\"), output_width)}: ', end='')
				rc, __out, __err = run_sp(['rm', path]).values()
				print('success' if rc == 0 else f'! failed: {__err}')
	else:
		print(f'const: {short_path}')

for path, id in remote_p2i.items():
	short_id = id[-6:]
	short_path = path.split('/')[-1]
	dist_path = './' + '/'.join(path.split('/')[2:])
	dist_folder = './' + '/'.join(path.split('/')[2:-1])
	if not id in installed_i2p.keys():
		if not dist_path in installed_paths:
			print(f'{get_aligned_string(str(f\"var: installing {short_path} from repo(id=..{short_id})\"), output_width)}: ', end='')
			rc, __out, __err = run_sp(['mkdir', '-p', dist_folder]).values()
			rc, __out, __err = run_sp(['cp', path, dist_path]).values()
			print('success' if rc == 0 else f'! failed: {__err}')
		elif not installed_is_const_p2i[dist_path]:
			print(f'{get_aligned_string(str(f\"var: installing {short_path} from repo(id=..{short_id})\"), output_width)}: ', end='')
			rc, __out, __err = run_sp(['cp', path, dist_path]).values()
			print('success' if rc == 0 else f'! failed: {__err}')
"

python3.11 -c "$python_script"
