## Intro & Architecture

You are tasked with maintaining a tool that helps with the management and automation of
tasks related to hundreds of MySQL databases. 

Your app (`pymanager`) keeps all of its internal state stored in a MySQL databases on
the `manager` host (the VM that `vagrant ssh` gets you in). To interact with it your
team has used the SQLAlchemy ORM and defined some classes that map to the tables in the
database (see `pymanager/models.py`). Your team has also "finished" the CLI and the API.
But there is a twist.

In the spirit of test-driven development the senior dev began writing some tests, but
then he left to work on his cat toy startup. The juniors in your team tried implementing
the specs, but their code doesn't pass the automated tests. To make things worse, the 
code they wrote is missing some things they never thought about.

**Your mission, should you choose to accept it:** Fix the code so it passes the existing 
tests, gets approved by the QA team, and finally gets deployed in production.  Hopefully 
without blowing up the Earth. It would be cool if you could work out at least 1 section 
from the extras.

You can find some more details in the specifications at the end, and in the various
docstrings around the codebase. If you're done and want a challenge, try going over
the next few sections (in order!). If something is unclear `refuse the temptation
to guess`, and if you find an error don't let it `pass silently`.

Don't overwork yourself, and make sure to have fun!

## Tool Requirements

This tool already exists and serves a few purposes, namely:
- CLI (see `pymanager/cli/commands.py`) to help database administrators (DBAs) perform
common operational tasks like start, stop, and view the health of MySQL databases. To
invoke it just type `pymanager` in your CLI. You can find some documentation in
`pymanager/cli/groups.py` about how it works. Click is used so you can check
[the Click docs](https://click.palletsprojects.com/en/7.x/) for more. The application
just runs the `root` function, imported in `pymanager/main.py`.
- API (see `pymanager/api/views.py`) to interact with tools developed by other teams,
dashboards, monitoring and reporting tools, etc. This runs in debug mode, and is
launched by running `python3 pymanager/main.py`.

Your test environment has 4 databases which are split into 2 pairs:
- `mysql-01-prod` (master) and `mysql-03-prod` (replica)
- `mysql-02-prod` (master) and `mysql-04-prod` (replica)

## Set Up Your Dev Environment

0. Get compatible versions of VirtualBox and Vagrant, and obviously Python. This setup
has been tested with the latest versions (6.1.18, 2.2.14, and 3.9.2 respectively) and on
Mac, Linux, and Windows. If however you have trouble getting things working drop us a
message.
1. Using your favorite Python interpreter, or in a new virtual environment,
run `pip install doit`.
2. Run `doit up` in your checkout. This will take a while (~5-20 minutes) and ~1.5 GB or
RAM because it builds:
    - 1 `manager` VM, the host where both your Python code lives and a MySQL database
    that is only for internal use by your code (i.e. holds application state).
    - 4 `mysql-0x-prod` VMs, where `1 =< x =< 4`, with your dev MySQL databases with
    dummy customer data. These are typically under heavy load from other apps. The
    databases consist of 2 primaries and 2 replicas, you can view the MySQL table for
    the initial configuration.
3. Use `vagrant ssh` to connect to the management host, or `vagrant ssh dbx` to connect
to the respective `mysql-0x-prod` host.
4. We recommend you set the interpreter in your IDE to be `/vagrant/venv/bin/python3` 
within `manager` vagrant instance
5. You can install additional packages with `pip3 install --user`, but remember to
also add them to the bottom of the requirements file
6. To destroy your VMs but not the base box run `doit clean up`. To destroy the whole
environment run `doit clean`.

## Helpers & Measuring Progress

The simplest way to measure progress is to run the various tests.
- `doit test_style`: checks the formatting of your code
- `doit test_units`: runs unit tests with pytest to verify the API and CLI work as
intended.
- `doit test_tables`: tests your SQLAlchemy models, it will print the first 2 rows for 
every model you have defined but it won't catch some mistakes so use it in conjunction 
with the database and the SQL dump file (see `devel/interview_tables_dump.sql`). 
- `doit test`: a shortcut to run all of the above.

The tests don't cover everything but are a good start.

Also you're free to use the existing helpers for connections to MySQL and running commands
remotely over SSH, modify or extend them as you see fit, or define your own helpers
for the same or other tasks. They're there to save you some time (and work!) and help
you get familiar with how a few libraries work. Here's a quick overview of the existing
ones:

Helper functions:
- `get_instance`: thin wrapper around querying with SQLAlchemy that throws an exception
if an instance was not found for a given host.
- `run_remotely`: run a shell command on another host using fabric2 and SSH.
- `get_mysql_report`: create a string report for MySQL instances that can be printed
in `pymanager mysql view`.

## Optional Extras

If you've gotten this far, you've done some stellar work as a junior developer. Want to 
really show off your python chops? Dive into at least one of the below and see what you 
can do.

### Extra 1: That was too easy

Your DBA pals are tired of constantly writing tons of SQL for creating new user accounts,
resetting passwords when existing users forget them, activating blocked accounts, and
fixing spelling mistakes in usernames. Automate their job by extending the CLI with
these commands:
- `pymanager add user`: Create a new user.
- `pymanager user list`: show all users and their IDs
- `pymanager user edit <id>`: change a user's name and/or status (feel free to break this
in multiple commands, use options, or whatever method makes more sense to you)

Your team has already implemented `pymanager user delete <id>` (you might need to fix
this too!).

### Extra 2: Still too easy

Extend both API and CLI with the ability to delete instances, but only allow users who
know the secret passphrase (`bronto123`) to call them.

### Extra 3: Far too easy

Both the CLI and API have some functionality to create a new instance. Try adding 1-3
more VMs (considering available RAM/CPU resources) and when a new instance is created
also make sure that MySQL is installed and started ("provisioning"). 

### Extra Extras: All of this was easy and fun

Extend your app with:
- monitoring & logging
- configuration management
- easier deployment, CI/CD pipelines
- demonstrate advanced knowledge & understanding of how DBs (and specifically
MySQL) work.
- make everything run fast as lightning
