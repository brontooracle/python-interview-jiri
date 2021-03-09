import os

from doit.tools import LongRunning
from doit_helpers import remove_files, touch


def task_build_base():
    """Create a base box to be used as a starting point for other VMs."""

    return {
        'targets': ['base.box'],
        # All files in ./devel
        'file_dep': [
            os.path.join(path, file)
            for path, d, files in os.walk("devel")
            for file in files
        ],
        'actions': [
            'vagrant up --provision base',
            'vagrant package --output base.box base',
        ],
        'clean': [
            'vagrant destroy -f base',
            (remove_files, ['.vagrant', 'base.box']),
        ],
        'uptodate': [os.path.exists('base.box')],
        'verbosity': 2,
    }


def task_up():
    """Prepare & bring up the work environment."""

    return {
        'file_dep': ['base.box'],
        'targets': ['provisioned'],
        'actions': [
            'vagrant up --provision db1 db2 db3 db4 manager',
            (touch, ['provisioned'])
        ],
        'clean': [
            'vagrant destroy -f db1 db2 db3 db4 manager',
            (remove_files, ['provisioned'])
        ],
        'uptodate': [os.path.exists('provisioned')],
        'verbosity': 2,
    }


def task_prepare_tests():
    """Install dependencies with pip3. No need to run directly."""

    get_libs = 'pip3 install --user -r /vagrant/requirements.txt'
    return {
        'actions': [
            'echo Installing python dependencies...',
            f"vagrant ssh -c '{get_libs}'",
            'echo Done',
        ]
    }


def task_test_tables():
    """Print a preview of your SQLAlchemy table definitions."""

    print_tables = 'python3 /vagrant/pymanager/models.py'
    return {
        'task_dep': ['prepare_tests'],
        'actions': [
            LongRunning('echo Testing SQLAlchemy tables...'),
            LongRunning('echo'),
            LongRunning(f"vagrant ssh -c '{print_tables}'"),
            LongRunning('echo Done'),
            LongRunning('echo'),
        ]
    }


def task_test_style():
    """Check for style errors."""

    style_check = 'cd /vagrant && flake8 pymanager'
    return {
        'task_dep': ['prepare_tests'],
        'actions': [
            LongRunning('echo'),
            LongRunning('echo Running style tests...'),
            LongRunning('echo'),
            LongRunning(f"vagrant ssh -c '{style_check}'"),
            LongRunning('echo Done'),
            LongRunning('echo'),
        ],
    }


def task_test_units():
    """Run automated tests using pytest"""
    return {
        'task_dep': ['prepare_tests'],
        'actions': [
            LongRunning('echo'),
            LongRunning('echo Running automated tests...'),
            LongRunning('echo'),
            LongRunning("vagrant ssh -c 'pytest /vagrant/tests'"),
            LongRunning('echo Done'),
            LongRunning('echo'),
        ]
    }


def task_test():
    """Run tests on the interviewee's solution."""

    return {
        'task_dep': ['test_tables', 'test_style', 'test_units'],
        'actions': [
            LongRunning('echo'),
            LongRunning('echo Tests finished...'),
            LongRunning('echo'),
        ],
    }
