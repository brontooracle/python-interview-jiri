from fabric2 import Connection

from pymanager.models import Instance


# ************ ADD OR MODIFY HELPER FUNCTIONS ************


def get_instance(host):
    instance = Instance.query.filter(Instance.host == host).first()
    if not instance:
        raise LookupError("Instance not found for this host.")

    return instance


def run_remotely(host, command):
    results = Connection(host).run(command, hide='both', warn=True)
    out = results.stdout.strip()
    err = results.stderr.strip()
    return out, err


def get_mysql_report(instance, cursor):
    if instance.role != "slave":
        return "MySQL role: master\n"

    interesting_data = ["Master_Host", "Slave_IO_Running",
                        "Slave_SQL_Running", "Seconds_Behind_Master", ]

    cursor.execute("SHOW SLAVE STATUS")
    columns = [i[0] for i in cursor.description]
    values = cursor.fetchone()

    report = "MySQL role: slave\n"
    for col_name, value in zip(columns, values):
        if col_name in interesting_data:
            report += f"\t{col_name}: {value}\n"

    return report
