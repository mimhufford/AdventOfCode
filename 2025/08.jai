day8 :: (input: string) -> string, string
{
    part1, part2 : s64;

    junctions : [..]Junction;
    array_reserve(*junctions, 1000);

    min_point := Vector3.{FLOAT32_MAX,FLOAT32_MAX,FLOAT32_MAX};
    max_point := Vector3.{};

    while input {
        j := array_add(*junctions);
        j.position.x = read_s64(*input).(float); advance(*input);
        j.position.y = read_s64(*input).(float); advance(*input);
        j.position.z = read_s64(*input).(float);

        min_point.x = min(j.position.x, min_point.x);
        min_point.y = min(j.position.y, min_point.y);
        min_point.z = min(j.position.z, min_point.z);
        max_point.x = max(j.position.x, max_point.x);
        max_point.y = max(j.position.y, max_point.y);
        max_point.z = max(j.position.z, max_point.z);
    }

    DIM :: 8;
    range := max_point - min_point + Vector3.{1,1,1};
    spatial : [DIM][DIM][DIM][..]*Junction;

    for * j: junctions {
        using bucket := (j.position - min_point) / range * DIM;
        array_add(*spatial[z.(s32)][y.(s32)][x.(s32)], j);
    }

    pairs : [..]Pair;

    pair_up :: (ps: *[..]Pair, js: []*Junction) {
        for a: 0..js.count-1 for b: a+1..js.count-1 array_add(ps, .{ distance_squared(js[a].position, js[b].position), js[a], js[b]});
    }

    pair_up :: (ps: *[..]Pair, js1: []*Junction, js2: []*Junction) {
        for a: js1 for b: js2 array_add(ps, .{distance_squared(a.position, b.position), a, b});
    }

    for z: 0..DIM-1 {
        for y: 0..DIM-1 {
            for x: 0..DIM-1 {
                pair_up(*pairs, spatial[z][y][x]);

                if z > 0     && y > 0     && x < DIM-1 pair_up(*pairs, spatial[z][y][x], spatial[z-1][y-1][x+1]);
                if z > 0                  && x < DIM-1 pair_up(*pairs, spatial[z][y][x], spatial[z-1][y+0][x+1]);
                if z > 0     && y < DIM-1              pair_up(*pairs, spatial[z][y][x], spatial[z-1][y+1][x+0]);
                if z > 0     && y < DIM-1 && x < DIM-1 pair_up(*pairs, spatial[z][y][x], spatial[z-1][y+1][x+1]);

                if              y > 0     && x < DIM-1 pair_up(*pairs, spatial[z][y][x], spatial[z+0][y-1][x+1]);
                if                           x < DIM-1 pair_up(*pairs, spatial[z][y][x], spatial[z+0][y+0][x+1]);
                if              y < DIM-1              pair_up(*pairs, spatial[z][y][x], spatial[z+0][y+1][x+0]);
                if              y < DIM-1 && x < DIM-1 pair_up(*pairs, spatial[z][y][x], spatial[z+0][y+1][x+1]);

                if z < DIM-1 && y > 0     && x < DIM-1 pair_up(*pairs, spatial[z][y][x], spatial[z+1][y-1][x+1]);
                if z < DIM-1                           pair_up(*pairs, spatial[z][y][x], spatial[z+1][y+0][x+0]);
                if z < DIM-1 &&              x < DIM-1 pair_up(*pairs, spatial[z][y][x], spatial[z+1][y+0][x+1]);
                if z < DIM-1 && y < DIM-1              pair_up(*pairs, spatial[z][y][x], spatial[z+1][y+1][x+0]);
                if z < DIM-1 && y < DIM-1 && x < DIM-1 pair_up(*pairs, spatial[z][y][x], spatial[z+1][y+1][x+1]);
            }
        }
    }

    convert_to_min_heap(pairs);

    circuits : [..]s64;

    for 0..S64_MAX {
        p := extract_min(*pairs);
        a, b := p.a, p.b;

        if a.circuit == -1 && b.circuit == -1 {
            array_add(*circuits, 2);
            a.circuit = circuits.count - 1;
            b.circuit = circuits.count - 1;
        } else if a.circuit == -1 {
            circuits[b.circuit] += 1;
            a.circuit = b.circuit;
            if circuits[b.circuit] == junctions.count { part2 = a.position.x.(s64) * b.position.x.(s64); break; }            
        } else if b.circuit == -1 {
            circuits[a.circuit] += 1;
            b.circuit = a.circuit;
            if circuits[a.circuit] == junctions.count { part2 = a.position.x.(s64) * b.position.x.(s64); break; }            
        } else if a.circuit != b.circuit {
            circuits[b.circuit] += circuits[a.circuit];
            circuits[a.circuit] = 0;
            c := a.circuit;
            for * junctions if it.circuit == c then it.circuit = b.circuit;
            if circuits[b.circuit] == junctions.count { part2 = a.position.x.(s64) * b.position.x.(s64); break; }            
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

#scope_file

Junction :: struct { position: Vector3; circuit := -1; }
Pair :: struct { distance: float; a: *Junction; b: *Junction; }

min_heap :: (a: []Pair, i: s64) {
    minimum := i; 

    l := 2 * i + 1; 
    if (l < a.count && a[l].distance < a[minimum].distance) minimum = l;

    r := 2 * i + 2; 
    if (r < a.count && a[r].distance < a[minimum].distance) minimum = r;

    if (minimum == i) return;

    swap(*a[i], *a[minimum]);
    min_heap(a, minimum);
}

convert_to_min_heap :: (a: []Pair) {
    for < 0..a.count / 2 - 1 min_heap(a, it);
}

extract_min :: (a: *[]Pair) -> Pair {
    value := a.*[0];
    array_unordered_remove_by_index(a, 0);
    min_heap(a.*, 0);
    return value;
}