from collections import defaultdict

from fastapi import APIRouter, Query

from ..schemas import ConceptOut, ShortNoteOut, UnitOut
from ..supabase_client import supabase_admin

router = APIRouter(prefix="/api/units", tags=["content"])


# Curriculum content is the same for every student in a grade, so this
# endpoint deliberately does not require a Supabase session — that lets
# Next.js cache the response and share it across every student in the
# grade instead of issuing one fetch (and one cache entry) per user.
@router.get("", response_model=list[UnitOut])
def list_units(grade: int = Query(ge=1, le=13)):
    units_result = (
        supabase_admin.table("units")
        .select("*")
        .eq("grade", grade)
        .order("sort_order")
        .execute()
    )
    units = units_result.data
    if not units:
        return []

    unit_ids = [unit["id"] for unit in units]

    concepts_result = (
        supabase_admin.table("concepts")
        .select("*")
        .in_("unit_id", unit_ids)
        .order("sort_order")
        .execute()
    )
    notes_result = (
        supabase_admin.table("short_notes")
        .select("*")
        .in_("unit_id", unit_ids)
        .order("sort_order")
        .execute()
    )

    concepts_by_unit: dict[int, list[dict]] = defaultdict(list)
    for concept in concepts_result.data:
        concepts_by_unit[concept["unit_id"]].append(concept)

    notes_by_unit: dict[int, list[dict]] = defaultdict(list)
    for note in notes_result.data:
        notes_by_unit[note["unit_id"]].append(note)

    return [
        UnitOut(
            id=unit["id"],
            grade=unit["grade"],
            name=unit["name"],
            sinhala_name=unit["sinhala_name"],
            accent_color=unit["accent_color"],
            icon_key=unit["icon_key"],
            description=unit["description"],
            concepts=[ConceptOut(**c) for c in concepts_by_unit[unit["id"]]],
            short_notes=[ShortNoteOut(**n) for n in notes_by_unit[unit["id"]]],
        )
        for unit in units
    ]
