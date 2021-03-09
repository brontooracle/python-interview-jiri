import re

import click
from MySQLdb import connect

from .groups import mysql, user
from pymanager.helpers import get_instance, run_remotely, get_mysql_report
from pymanager.models import User


# ************ ADD OR MODIFY CLICK CLI COMMANDS ************


@mysql.command()
@click.argument("host", nargs=1)
def view(host):
    """View status and other information about a MySQL instance.

    \b
    Args:
        host (str): Hostname of the MySQL server.
    """

    out, err = run_remotely(host, 'sudo systemctl status mysqld')
    status = re.findall(r"Active:\s+(\w+) ", out)
    if status:
        click.echo("Status: " + status[0])

    instance = get_instance(host)
    connection = connect(host=instance.host, port=instance.port,
                         user="bronto", passwd="bronto")
    cursor = connection.cursor()

    cursor.execute("SELECT @@VERSION")
    version = cursor.fetchone()[0]
    click.echo("Version: " + version.strip("-log"))

    info_report = get_mysql_report(instance, cursor)
    click.echo(info_report)

    cursor.close()
    connection.close()


@mysql.command()
@click.argument("host", nargs=1)
def start(host):
    """Start a MySQL instance.

    \b
    Args:
        host (str): Hostname of the MySQL server.
    """
    instance = get_instance(host)
    out, err = run_remotely(host, 'sudo systemctl start mysqld')
    click.echo("MySQL started.")

    # Make sure to start replication if it's a replica DB!
    if instance.role == "slave":
        run_remotely(host, 'mysql -e "START SLAVE;"')

    click.echo("\nHealth report:")
    connection = connect(host=instance.host, port=instance.port,
                         user="bronto", passwd="bronto")
    cursor = connection.cursor()

    info_report = get_mysql_report(instance, cursor)
    click.echo(info_report)

    cursor.close()
    connection.close()


@mysql.command()
@click.argument("host", nargs=1)
def stop(host):
    """Stop a MySQL instance.

    \b
    Args:
        host (str): Hostname of the MySQL server.
    """
    instance = get_instance(host)
    out, err = run_remotely(host, 'sudo systemctl stop mysqld')
    click.echo("MySQL stopped.")


@user.command()
@click.argument("user_id", nargs=1, type=int)
def delete(user_id):
    User.delete(user_id).commit()
