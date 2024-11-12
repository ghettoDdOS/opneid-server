from fastapi import APIRouter

root_router = APIRouter()


@root_router.get('/ping')
def ping():
    return 'pong'
