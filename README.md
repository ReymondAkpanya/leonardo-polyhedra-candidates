# Leonardo Polyhedra — Candidate Surfaces

Combinatorial candidates for *Leonardo polyhedra*: triangulated surfaces of genus ≥ 2
whose combinatorial automorphism group contains a subgroup isomorphic to one of the
rotation groups of the Platonic solids — `A_4`, `S_4` or `A_5`.

Such a subgroup is a necessary condition for an embedding in `R^3` with full polyhedral
symmetry, so these surfaces are the starting point for a geometric realisation search.

## Where the data comes from

The input is the face-transitive surfaces database
(<https://github.com/jspreer/faceTransitiveSurfaces>). For every surface in it, `script.g`
(GAP, using the [`SimplicialSurfaces`](https://github.com/gap-packages/SimplicialSurfaces)
and `sonata` packages):

1. keeps only surfaces with Euler characteristic ≤ −1 (genus ≥ 2),
2. discards surfaces whose automorphism group order (`#faces × |face stabilizer|`, read
   off the vertex-face type) is not divisible by 12, 24 or 60 — a cheap necessary
   condition,
3. computes the automorphism group acting on the faces and runs over its conjugacy
   classes of subgroups, recording the surface whenever a subgroup isomorphic to
   `A_4` (order 12), `S_4` (order 24) or `A_5` (order 60) exists.

A surface is written once per matching group, so the same surface can appear in the
`A_4`, `S_4` and `A_5` files.

## `candidates_leonardo/`

179 plain-text files, ~304 MB, **22,441 surface records** in total. File names follow

```
surfaces_<minFaces>_<maxFaces>_<group>_<class>
```

* `<minFaces>_<maxFaces>` — the face-count range of the batch the surface came from.
  Ranges present: `4_300`, `302_400`, `402_500`, `502_550`, `552_600`, `602_650`,
  `652_700`, `702_750`, `752_768`, `770_830`, `832_870`, `872_900`, `902_958`, `960_960`,
  `962_1022`, `1024_1024`, `1026_1070`, `1072_1100`, `1102_1150`, `1152_1152`,
  `1154_1198`, `1200_1220`, `1222_1240`, `1242_1260`, `1262_1278`, `1280_1280`.
* `<group>` — `A_4`, `S_4` or `A_5`, the Platonic rotation group found in the
  automorphism group.
* `<class>` — combinatorial type of the surface:
  * `regular` — the surface is regular, i.e. vertex-face type `<1,6>` in the source
    database (the face stabilizer is the full symmetry group of the triangle, so the
    action is flag-transitive),
  * `equivelar` — all vertices have the same face degree,
  * `others` — mixed vertex degrees.

### Counts by group and class

| group | regular | equivelar | others | total |
|-------|--------:|----------:|-------:|------:|
| `A_4` | 171 | 4,150 | 6,281 | 10,602 |
| `S_4` | 149 | 3,657 | 5,467 |  9,273 |
| `A_5` |  51 |   897 | 1,618 |  2,566 |
| **total** | **371** | **8,704** | **13,366** | **22,441** |

### File format

Each file is a sequence of surface records separated by a blank line. One record is the
`VerticesOfFaces` list of the simplicial surface in GAP syntax — a list of triangles,
each a list of three vertex labels, wrapped at 80 columns:

```
[ [ 10, 11, 12 ], [ 8, 9, 12 ], [ 7, 10, 11 ], [ 5, 6, 12 ], [ 4, 6, 9 ], [ 3, 5, 11 ],
  [ 2, 3, 8 ], [ 1, 3, 9 ], ... ]

[ [ 22, 23, 24 ], [ 21, 22, 23 ], ... ]
```

Vertices are numbered `1..n`; the triangles determine the surface completely.

Reading one file back into GAP:

```gap
LoadPackage("SimplicialSurfaces");
vof  := EvalString(record);                      # one blank-line-separated record
surf := SimplicialSurfaceByVerticesInFaces(vof);
```

Extracting the triangles with Python:

```python
import re
records = open(path).read().split("\n\n")
faces = [[tuple(map(int, t)) for t in re.findall(r"\[\s*(\d+),\s*(\d+),\s*(\d+)\s*\]", r)]
         for r in records if r.strip()]
```

## `script.g`

The GAP script that generated the files: `AllCandidatesOfAutomorphismGroups` for the
subgroup search, and `LeonardoSearch(content)` which walks the batch directories under
`RES/` and writes the `surfaces_*` files.
