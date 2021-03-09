from MySQLdb import connect


# Feel free to fix this (and the tests) if you fix the other one ;)
def run_mysql(command):
    connection = connect(host="manager", port=3306, user="bronto",
                         passwd="bronto", db="bronto")
    cursor = connection.cursor()

    cursor.execute(command)
    columns = [i[0] for i in cursor.description]
    results = cursor.fetchall()

    cursor.close()
    connection.close()

    return results, columns
