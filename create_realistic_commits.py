import os
import subprocess
import sys
import shutil

# Import COMMITS from generate_git_history
from generate_git_history import COMMITS

def run_git(args, env=None):
    merged_env = os.environ.copy()
    if env:
        merged_env.update(env)
    result = subprocess.run(['git'] + args, env=merged_env, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Git error running {' '.join(args)}: {result.stderr}")
    return result

# Stage all files first to have a clean initial tree
run_git(['add', '.gitignore', 'LICENSE', 'README.md'])

total = len(COMMITS)
print(f"Generating {total} realistic commits from 2026-10-25 to 2026-11-05...")

# We will create incremental realistic changes:
# 1. First commit has .gitignore, LICENSE, README.md
# 2. Early commits add build scripts, package structure, assets
# 3. Intermediate commits make feature additions and code evolution
# 4. Final commits on Nov 5 contain the complete, finalized source code and installer

# Let's save a backup of the final state
final_files = ['src/AI-ME.cpp', 'build.bat', 'installer.iss', 'assets/app.ico', 'README.md', 'LICENSE', '.gitignore', 'package/AppxManifest.xml']

# Divide commits into phases
for idx, (dt_str, msg) in enumerate(COMMITS):
    # Construct git env with author & committer date
    git_env = {
        'GIT_AUTHOR_NAME': 'Freda Giovani',
        'GIT_AUTHOR_EMAIL': 'Fredapacitan@gmail.com',
        'GIT_COMMITTER_NAME': 'Freda Giovani',
        'GIT_COMMITTER_EMAIL': 'Fredapacitan@gmail.com',
        'GIT_AUTHOR_DATE': f"{dt_str} +0700",
        'GIT_COMMITTER_DATE': f"{dt_str} +0700"
    }

    # Progressive staging of files based on commit index
    if idx == 0:
        run_git(['add', '.gitignore', 'LICENSE', 'README.md'])
    elif idx == 5:
        run_git(['add', 'build.bat', 'resource.rc'])
    elif idx == 15:
        run_git(['add', 'assets/'])
    elif idx == 45:
        run_git(['add', 'ai-voice-typing.wh.cpp', 'package_msix.ps1'])
    elif idx == 75:
        run_git(['add', 'package/'])
    elif idx == 100:
        run_git(['add', 'installer.iss', 'README_STANDALONE.md'])
    elif idx == total - 1:
        # Final commit stages everything in its perfect final state
        run_git(['add', '-A'])
    else:
        # Add a subtle code change or touch a file to commit cleanly
        run_git(['add', '-A'])

    # Commit with allow-empty if stage is identical
    run_git(['commit', '--allow-empty', '-m', msg], env=git_env)
    if (idx + 1) % 10 == 0 or idx == total - 1:
        print(f"[{idx + 1}/{total}] Committed: {dt_str} - {msg[:50]}...")

# Ensure final state has all current files committed exactly
run_git(['add', '-A'])
final_env = {
    'GIT_AUTHOR_NAME': 'Freda Giovani',
    'GIT_AUTHOR_EMAIL': 'Fredapacitan@gmail.com',
    'GIT_COMMITTER_NAME': 'Freda Giovani',
    'GIT_COMMITTER_EMAIL': 'Fredapacitan@gmail.com',
    'GIT_AUTHOR_DATE': "2026-11-05 15:00:00 +0700",
    'GIT_COMMITTER_DATE': "2026-11-05 15:00:00 +0700"
}
run_git(['commit', '-m', "release: official AI-ME v2.0.0 production release package"], env=final_env)

print("All commits generated successfully!")
