day8 :: (input: string) -> string, string
{
    part1, part2 : s64;

    Junction :: struct { position: Vector3; circuit := -1; }
    Pair :: struct { distance: float; a: *Junction; b: *Junction; }

    junctions : [..]Junction;
    pairs : [..]Pair;

    array_reserve(*junctions, 1000);
    array_reserve(*pairs, 500000);

    while input {
        j := array_add(*junctions);
        j.position.x = read_s64(*input).(float); advance(*input);
        j.position.y = read_s64(*input).(float); advance(*input);
        j.position.z = read_s64(*input).(float);
    }

    for a: 0..junctions.count-1 {
        for b: a+1..junctions.count-1 {
            p := array_add(*pairs);
            p.distance = distance_squared(junctions[a].position, junctions[b].position);
            p.a = *junctions[a];
            p.b = *junctions[b];
        }
    }

    quick_sort(pairs, p => p.distance);

    circuits : [..][..]*Junction;

    for 0..S64_MAX {
        a := pairs[it].a;
        b := pairs[it].b;

        if a.circuit == -1 && b.circuit == -1 {
            c := array_add(*circuits);
            array_add(c, a);
            array_add(c, b);
            a.circuit = circuits.count - 1;
            b.circuit = circuits.count - 1;
            if c.count == junctions.count { part2 = (a.position.x * b.position.x).(s64); break; }            
        } else if a.circuit == -1 {
            array_add(*circuits[b.circuit], a);
            a.circuit = b.circuit;
            if circuits[b.circuit].count == junctions.count { part2 = (a.position.x * b.position.x).(s64); break; }            
        } else if b.circuit == -1 {
            array_add(*circuits[a.circuit], b);
            b.circuit = a.circuit;
            if circuits[a.circuit].count == junctions.count { part2 = (a.position.x * b.position.x).(s64); break; }            
        } else if a.circuit != b.circuit {
            for circuits[a.circuit] {
                it.circuit = b.circuit;
                array_add(*circuits[b.circuit], it);
                remove it;
            }
            if circuits[b.circuit].count == junctions.count { part2 = (a.position.x * b.position.x).(s64); break; }            
        }

        // if it == 999 {
            // quick_sort(circuits, c => c.count);
            // part1 = circuits[circuits.count-1].count * circuits[circuits.count-2].count * circuits[circuits.count-3].count;
        // }
    }

    return tprint("%", part1), tprint("%", part2);
}