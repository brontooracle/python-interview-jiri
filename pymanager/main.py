from pymanager.api.views import app
from pymanager.cli.groups import root  # noqa
from pymanager.cli import commands  # noqa


if __name__ == "__main__":
    app.run(port=5000, debug=True)
