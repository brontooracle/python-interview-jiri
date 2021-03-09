from pymanager.models import Instance, Session
from .server import app


@app.route("/api/instances")
def instances():
    from flask import request

    instances = Instance.query.all()
    if request.json["full"]:
        return {"instances": [{"id": inst.id,
        "host": inst.host,
        "port": inst.port,
        "shard_id": inst.shard_id,
        "role": inst.role,
        "service": inst.service.name,
        } for inst in instances]}

    else:
        return {"instances": [inst.id for inst in instances]}, 200

    print(request.method is "POST")
    if request.method is "POST":
        service_id = request.json["service_id"]
        host = request.json["host"]
        port = request.json["port"]
        role = request.json.get("role", "master")

        instance = Instance(service_id= service_id,host= host,port=port,role= role)
        Session.add(instance)
        Session.flush()

        return {"id": instance.id}, 302


@app.route("/api/instance/<int:instance_id>", methods=["PUT", "POST"])
def instance_detail(instance_id):
    from flask import request



    instance = Instance.query.get(instance_id)
    if request.method == "PUT":
        instance.service_id = request.json.get("service_id", instance.service_id)
        new_role = request.json["role"]
        if new_role:
            instance.role = new_role

        return {"id": inst.id,
                       "host": inst.host,
                       "port": inst.port,
                       "role": inst.role,
                       "service": inst.service.name,
                       } , 206

    else:
        return {"id": inst.id,
                "host": inst.host,
                "port": inst.port,
                "role": inst.role,
                }, "OK"
