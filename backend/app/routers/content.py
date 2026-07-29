from collections import defaultdict

from fastapi import APIRouter, Depends, HTTPException, Query, status

from ..deps import CurrentTeacher, get_current_teacher, require_grade_access
from ..schemas import ConceptOut, ShortNoteOut, UnitIn, UnitOut
from ..supabase_client import supabase_admin

router = APIRouter(prefix="/api/units", tags=["content"])


def _assemble_units(units: list[dict]) -> list[UnitOut]:
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
            sort_order=unit["sort_order"],
            concepts=[ConceptOut(**c) for c in concepts_by_unit[unit["id"]]],
            short_notes=[ShortNoteOut(**n) for n in notes_by_unit[unit["id"]]],
        )
        for unit in units
    ]


def _replace_children(unit_id: int, payload: UnitIn) -> None:
    supabase_admin.table("concepts").delete().eq("unit_id", unit_id).execute()
    supabase_admin.table("short_notes").delete().eq("unit_id", unit_id).execute()

    if payload.concepts:
        supabase_admin.table("concepts").insert(
            [{"unit_id": unit_id, **c.model_dump()} for c in payload.concepts]
        ).execute()

    if payload.short_notes:
        supabase_admin.table("short_notes").insert(
            [{"unit_id": unit_id, **n.model_dump()} for n in payload.short_notes]
        ).execute()


# Curriculum content is the same for every student in a grade, so these two
# GET endpoints deliberately do not require a Supabase session — that lets
# Next.js cache the response and share it across every student in the grade
# instead of issuing one fetch (and one cache entry) per user. Writes below
# are teacher-only and scoped to the grades that teacher is assigned to.
@router.get("", response_model=list[UnitOut])
def list_units(grade: int = Query(ge=1, le=13)):
    units_result = (
        supabase_admin.table("units")
        .select("*")
        .eq("grade", grade)
        .order("sort_order")
        .execute()
    )
    return _assemble_units(units_result.data)


@router.get("/{unit_id}", response_model=UnitOut)
def get_unit(unit_id: int):
    result = supabase_admin.table("units").select("*").eq("id", unit_id).limit(1).execute()
    if not result.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Unit not found")
    return _assemble_units(result.data)[0]


@router.post("", response_model=UnitOut, status_code=status.HTTP_201_CREATED)
def create_unit(payload: UnitIn, teacher: CurrentTeacher = Depends(get_current_teacher)):
    require_grade_access(payload.grade, teacher)

    unit_fields = payload.model_dump(exclude={"concepts", "short_notes"})
    result = supabase_admin.table("units").insert(unit_fields).execute()
    if not result.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Could not create unit"
        )

    unit_id = result.data[0]["id"]
    _replace_children(unit_id, payload)
    return get_unit(unit_id)


@router.put("/{unit_id}", response_model=UnitOut)
def update_unit(
    unit_id: int, payload: UnitIn, teacher: CurrentTeacher = Depends(get_current_teacher)
):
    existing = supabase_admin.table("units").select("grade").eq("id", unit_id).limit(1).execute()
    if not existing.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Unit not found")

    require_grade_access(existing.data[0]["grade"], teacher)
    require_grade_access(payload.grade, teacher)

    unit_fields = payload.model_dump(exclude={"concepts", "short_notes"})
    supabase_admin.table("units").update(unit_fields).eq("id", unit_id).execute()
    _replace_children(unit_id, payload)
    return get_unit(unit_id)


@router.delete("/{unit_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_unit(unit_id: int, teacher: CurrentTeacher = Depends(get_current_teacher)):
    existing = supabase_admin.table("units").select("grade").eq("id", unit_id).limit(1).execute()
    if not existing.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Unit not found")

    require_grade_access(existing.data[0]["grade"], teacher)
    supabase_admin.table("units").delete().eq("id", unit_id).execute()
