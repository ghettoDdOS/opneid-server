from fastapi import FastAPI
from fastapi.responses import ORJSONResponse

from opneid_server.router import root_router


def get_application():
    return FastAPI(
        routes=root_router.routes,
        default_response_class=ORJSONResponse,
    )


application = get_application()
