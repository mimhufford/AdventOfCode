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

    circuits : [..]s64;

    for 0..S64_MAX {
        a := pairs[it].a;
        b := pairs[it].b;

        if a.circuit == -1 && b.circuit == -1 {
            array_add(*circuits, 2);
            a.circuit = circuits.count - 1;
            b.circuit = circuits.count - 1;
        } else if a.circuit == -1 {
            circuits[b.circuit] += 1;
            a.circuit = b.circuit;
            if circuits[b.circuit] == junctions.count { part2 = (a.position.x * b.position.x).(s64); break; }            
        } else if b.circuit == -1 {
            circuits[a.circuit] += 1;
            b.circuit = a.circuit;
            if circuits[a.circuit] == junctions.count { part2 = (a.position.x * b.position.x).(s64); break; }            
        } else if a.circuit != b.circuit {
            circuits[b.circuit] += circuits[a.circuit];
            circuits[a.circuit] = 0;
            c := a.circuit;
            for * junctions if it.circuit == c then it.circuit = b.circuit;
            if circuits[b.circuit] == junctions.count { part2 = (a.position.x * b.position.x).(s64); break; }            
        }

        if it == 999 {
            b1, b2, b3: s64;
            for circuits {
                if it > b1 { b1, b2, b3 = it, b1, b2; continue; }
                if it > b2 { b1, b2, b3 = b1, it, b2; continue; }
                if it > b3 { b1, b2, b3 = b1, b2, it; continue; }
            }
            part1 = b1 * b2 * b3;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}