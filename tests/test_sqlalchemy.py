import pytest
from sqlalchemy import inspect

from pymanager.models import defined_models
from helpers import run_mysql


def test_number_models_defined():
    """All tables in the manager MySQL DB have SQLAlchemy classes."""
    tables, _ = run_mysql("SHOW TABLES;")
    assert len(defined_models) == len(tables)


@pytest.mark.parametrize("model", defined_models)
def test_defined_table_names(model):
    """All of the initial tables exist, and with the same name."""
    required_tables = {"user", "service", "role", "permission", "instance"}

    defined_tables = []
    for model in defined_models:
        defined_tables.append(model.__tablename__)

    assert len(required_tables.difference(defined_tables)) == 0


@pytest.mark.parametrize("model", defined_models)
def test_defined_table_columns(model):
    """The number of columns from MySQL must match those in SQLAlchemy."""
    inst = inspect(model)
    columns_from_model = [c_attr.key for c_attr in inst.mapper.column_attrs]
    _, columns = run_mysql(f"SELECT * FROM {model.__tablename__} LIMIT 1;")

    assert len(columns) == len(columns_from_model)
    assert set(columns) == set(columns_from_model)
