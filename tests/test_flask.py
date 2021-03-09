import random
from pymanager.api.server import app
from pymanager.api import views  # noqa
from helpers import run_mysql


def test_api_returns_json():
    with app.test_client() as client:
        response = client.get('/api/instances')
        response_full = client.get('/api/instances', json={"full": True})

    assert hasattr(response, "json")
    assert hasattr(response_full, "json")

    assert isinstance(response.json, dict)
    assert isinstance(response_full.json, dict)


def test_number_instances():
    with app.test_client() as client:
        instances = client.get('/api/instances').json
        instances_full = client.get('/api/instances', json={"full": True}).json

    db_instances, _ = run_mysql("SELECT * FROM instance;")

    assert len(instances["instances"]) == len(instances_full["instances"])
    assert len(instances["instances"]) == len(db_instances)


def test_all_instances_types():
    with app.test_client() as client:
        instances = client.get('/api/instances').json

    assert "instances" in instances
    # The response is a dict containing a list of ints
    assert isinstance(instances["instances"], list)


def test_all_instances_types_full():
    with app.test_client() as client:
        instances = client.get('/api/instances', json={"full": True}).json

    # The response is a dict containing a list of dicts
    assert isinstance(instances["instances"], list)
    assert all(isinstance(instance, dict)
               for instance in instances["instances"])


def test_instances_contents():
    """Only int IDs are returned"""
    with app.test_client() as client:
        instances = client.get('/api/instances').json

    assert all(isinstance(id_, int) for id_ in instances["instances"])


def test_instances_contents_full():
    """All columns are returned for all rows"""
    with app.test_client() as client:
        instances = client.get('/api/instances', json={"full": True}).json

    assert all(x in instance
               for instance in instances["instances"]
               for x in ["host", "port", "role", "service"])


def test_instance_detail_get():
    """All columns are returned for 1 instance"""
    with app.test_client() as client:
        instance = client.get("/api/instance/1").json

    assert isinstance(instance, dict)
    assert all(x in instance for x in ["host", "port", "role", "service"])


def test_instance_detail_put():
    """All columns are returned for 1 instance and the value changed."""
    with app.test_client() as client:
        instance = client.put("/api/instance/1", json={"role": "slave"}).json
        assert isinstance(instance, dict)
        assert all(x in instance for x in ["host", "port", "role", "service"])
        assert instance["role"] == "slave"

        instance = client.put("/api/instance/1", json={"role": "master"}).json
        assert isinstance(instance, dict)
        assert all(x in instance for x in ["host", "port", "role", "service"])
        assert instance["role"] == "master"


def test_instance_detail_put_nonsense():
    """Test is the given role is getting checked."""
    with app.test_client() as client:
        resp = client.put("/api/instance/1", json={"role": "replica"})

    instance = resp.json

    assert resp.status_code == 400
    assert isinstance(instance, dict)
    assert "message" in instance


def test_instance_detail_post():
    with app.test_client() as client:
        instance = client.post("/api/instances", json={
            "role": "slave",
            # Sorry if this breaks the tests
            "host": f"mysql-{random.randint(100_000, 1_000_000)}-prod",
            "port": random.randint(1, 30_000),
            "service_id": 1,
        }).json

    assert isinstance(instance, dict)
    assert "id" in instance
    assert isinstance(instance["id"], int)


def test_instances_post_nonsense():
    with app.test_client() as client:
        resp = client.post("/api/instances", json={
            "role": "eggplant",
            "host": "abcdefghijklmnopqrstuvxyz" * 100,
            "port": "no",
            "service_id": 99,
        })

    instance = resp.json

    assert resp.status_code == 400
    assert isinstance(instance, dict)
    assert "message" in instance
