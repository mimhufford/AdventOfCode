day3 :: (input: string) -> string, string
{
    part1, part2 := 0;
    V2 :: struct { x, y: s32; #overlay(x) hash: u64; }

    ids : [..]s64;
    overlap_ids : Table(s64, u8);
    map : Table(u64, [..]s64);

    while input {
        id := get(s64, *input);
        cx := get(s64, *input);
        cy := get(s64, *input);
        cw := get(s64, *input);
        ch := get(s64, *input);

        array_add(*ids, id);

        for y: cy..cy+ch-1 {
            for x: cx..cx+cw-1 {
                pos := V2.{x.(s32), y.(s32)};
                cell := find_or_add(*map, pos.hash);
                array_add(cell, id);
                if cell.*.count == 2 part1 += 1;
            }
        }
    }

    for occupants: map {
        if occupants.count == 1 continue;
        for occupants find_or_add(*overlap_ids, it);
    }

    for id: ids {
        if table_contains(*overlap_ids, id) continue;
        part2 = id;
        break;
    }

    return tprint("%", part1), tprint("%", part2);
}