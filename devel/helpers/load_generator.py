"""
Load generating tool that could be used for DBA interviews. For python
interviews this doesn't get installed on the servers.
"""

import time
import random
from subprocess import run
from threading import Thread


CONCURRENT_REQUESTS = 20

# query, (host1, host2, ...), probability
query_templates = [
    [
        "SELECT * FROM employees.employees LIMIT {};",
        ("mysql-01-prod", "mysql-02-prod"),
        5
    ],

    [
        "SELECT * FROM employees.departments LIMIT {};",
        ("mysql-01-prod", "mysql-02-prod"),
        25
    ],

    [
        "SELECT * FROM employees.current_dept_emp LIMIT {};",
        ("mysql-01-prod", "mysql-02-prod"),
        20
    ],

    [
        "SELECT * FROM sakila.actor LIMIT {};",
        ("mysql-03-prod", "mysql-04-prod"),
        25
    ],

    [
        "SELECT * FROM sakila.address LIMIT {};",
        ("mysql-03-prod", "mysql-04-prod"),
        25
    ],
]

# Convert weights to percentages
total_weight = sum(q[-1] for q in query_templates)
weights = [q[-1] / total_weight for q in query_templates]


while True:
    queries = random.choices(query_templates,
                             weights=weights,
                             k=CONCURRENT_REQUESTS)

    threads = []
    for (query, hosts, _) in queries:
        # Query for a random number of rows
        query = query.format(random.randint(10, 1000))
        # Query a random host
        host = random.choice(hosts)

        command = ["mysql", "-h", host, "-e", query]

        t = Thread(target=run, args=(command,))
        t.start()
        time.sleep(0.05)
        threads.append(t)

    # Wait till the all finish
    for t in threads:
        t.join()

    time.sleep(0.5)
