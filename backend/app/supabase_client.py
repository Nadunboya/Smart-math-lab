from supabase import Client, create_client

from .config import settings

# Uses the service_role key: bypasses RLS, so every query below must be scoped
# to the authenticated caller's own user id — never trust client-supplied ids.
supabase_admin: Client = create_client(settings.supabase_url, settings.supabase_service_role_key)
