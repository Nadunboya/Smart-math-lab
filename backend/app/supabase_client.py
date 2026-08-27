import time
from typing import Any, Callable, TypeVar

import httpx
from supabase import Client, create_client

from .config import settings

# Uses the service_role key: bypasses RLS, so every query below must be scoped
# to the authenticated caller's own user id — never trust client-supplied ids.
supabase_admin: Client = create_client(settings.supabase_url, settings.supabase_service_role_key)

T = TypeVar("T")

# postgrest's HTTP/2 connections occasionally get dropped mid-request
# ("Server disconnected") with no application-level cause — retrying on a
# fresh connection resolves it. build_query is called again on each retry
# (not just .execute()) since a request builder may not be safely reusable
# after a failed send.
_TRANSIENT_ERRORS = (httpx.RemoteProtocolError, httpx.ConnectError, httpx.ReadError, httpx.WriteError)


def execute_with_retry(build_query: Callable[[], Any], retries: int = 2, backoff: float = 0.5) -> Any:
    for attempt in range(retries + 1):
        try:
            return build_query().execute()
        except _TRANSIENT_ERRORS:
            if attempt == retries:
                raise
            time.sleep(backoff * (attempt + 1))
