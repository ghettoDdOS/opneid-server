from fastapi import FastAPI

from opneid_server.router import root_router


def get_application():
    return FastAPI(routes=root_router.routes)


application = get_application()
