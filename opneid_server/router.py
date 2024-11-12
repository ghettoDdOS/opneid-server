from typing import Literal

from fastapi import APIRouter

root_router = APIRouter()


@root_router.get('/ping', response_model=Literal['pong'])
def ping():
    return 'pong'
