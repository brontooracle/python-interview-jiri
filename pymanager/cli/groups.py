"""
The `root` group is what gets called when you run `pymanager` in your terminal.
A command group is nothing more than a prefix for your CLI. The `mysql` and `user`
groups will hold all of the commands you'll implement. If you want you can define
other custom command groups at the end, but you probably don't need to. Here are
a few example invocations of the CLI:

# Help menus
pymanager --help
pymanager mysql
pymanager mysql --help

# Run a command from the `mysql` group
pymanager mysql start mysql-04-prod
pymanager mysql stop mysql-01-prod

# Run the `newcommand` command from your custom `newgroup` group
pymanager newgroup newcommand
"""

import click


@click.group()
def root():
    """A command-line tool to help you with your daily OPS tasks."""
    pass


@root.group()
def mysql():
    """Group of commands for MySQL instances."""
    pass


@root.group()
def user():
    """Group of user administration commands."""
    pass
