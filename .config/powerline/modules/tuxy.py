import os

def sandbox_id():
    return os.environ.get('SANDBOX_ID')

def sandbox_perforce_branch_name():
    return os.environ.get('BRANCHNAME')

def sandbox_flavor():
    return os.environ.get('FLAVOR')
