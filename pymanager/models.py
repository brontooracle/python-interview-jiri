"""SQLAlchemy definitions for the database tables on the PyManager DB. If you want
to take a look at the SQL code, they are defined in devel/interview_tables_dump.sql.

To see a preview of how your models correspond to the tables in the database you
can run this `doit preview_tables` or run this file from inside vagrant (e.g.:
    python3 /vagrant/pymanager/models.py

This doesn't validate your code (there are tests for that!), it just prints the
first 2 rows of every defined table.
"""

from inspect import isclass

from tabulate import tabulate
from sqlalchemy import inspect, create_engine, Column, ForeignKey, UniqueConstraint
from sqlalchemy.orm import relationship, scoped_session, sessionmaker, Query
from sqlalchemy.dialects.mysql import ENUM, INTEGER, SMALLINT, VARCHAR, DATETIME
from sqlalchemy.ext.declarative import declarative_base


# The bronto database contains the state the app needs to run
uri = 'mysql+mysqldb://bronto:bronto@manager:3306/bronto'
engine = create_engine(uri)
Session = scoped_session(sessionmaker(engine, autocommit=True, autoflush=False,
                                      expire_on_commit=False))

Base = declarative_base()
Base.query = Session.query_property(query_cls=Query)


# ************ ADD OR MODIFY TABLES BELOW ************


class Instance(Base):
    __tablename__ = "instance"
    __table_args__ = (
        UniqueConstraint('host', 'port'),
    )

    id = Column(INTEGER(10, unsigned=True), primary_key=True)
    host = Column(VARCHAR(128), nullable=False)
    port = Column(SMALLINT(5, unsigned=True), nullable=False)
    role = Column(ENUM("master", "slave", 'other'), nullable=False, default="master")


class Permission(Base):
    __tablename__ = "permission"
    __table_args__ = (
        UniqueConstraint('user_id', 'role_id'),
    )

    id = Column(INTEGER(10, unsigned=True), primary_key=True)
    user_id = Column(INTEGER(10, unsigned=True), ForeignKey("user.id"),
                     nullable=True, default=None)
    role_id = Column(INTEGER(10, unsigned=True), ForeignKey("role.id"),
                     nullable=True, default=None)


# Note: this role is a user role, not a MySQL role
class Role(Base):
    __tablename__ = "role"

    id = Column(INTEGER(10, unsigned=True), primary_key=True)
    name = Column(VARCHAR(255), nullable=False, unique=True)
    permissions = Column(VARCHAR(255), nullable=False)

    perms = relationship("Permission", backref="role")


class Service(Base):
    __tablename__ = "service"
    id = Column(INTEGER(10, unsigned=True), primary_key=True)


class User(Base):
    __tablename__ = "user"

    id = Column(INTEGER(10, unsigned=True), primary_key=True)
    name = Column(VARCHAR(30), nullable=False, unique=True)
    create_date = Column(VARCHAR(41), nullable=False)
    status = Column(ENUM("active", "inactive", 'terminated'),
                    nullable=True, default=None)

    permissions = relationship("Permission", backref="user")


# ************ DO NOT MODIFY THE LINES BELOW ************

def trim(item):
    if isinstance(item, str) and len(item) > 20:
        return item[:15] + "..."
    return item


defined_models = []
for _, obj in globals().copy().items():
    if isclass(obj) and issubclass(obj, Base) and obj is not Base:
        defined_models.append(obj)


if __name__ == "__main__":
    for model in defined_models:
        try:
            inst = inspect(model)
            column_names = [c_attr.key for c_attr in inst.mapper.column_attrs]

            data = []
            for obj in model.query.limit(2).all():
                # Get all columns and trim them if needed
                data.append([trim(getattr(obj, col)) for col in column_names])

            table = tabulate(data, headers=column_names, tablefmt="fancy_grid")
            print(f"Table `{model.__tablename__}`:")
            print(table, end="\n\n")
        except Exception as e:
            print(f"Printing table `{model.__tablename__}` failed. Error: {e}\n")
