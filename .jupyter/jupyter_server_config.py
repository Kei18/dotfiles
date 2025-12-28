# Configuration file for jupyter-server.

c = get_config()  # noqa

c.ContentsManager.allow_hidden = True
c.ServerApp.allow_root = True
c.ServerApp.open_browser = False
