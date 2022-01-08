day24 :: (data: string) -> string, string
{
    wall : [U16_MAX]bool;
    locs : [8]Position;
    dist : [8][8]int;

    lines := split(data, "\n");
    lines.count -= 1;

    for line, y: lines
    {
        pos : Position;
        pos.y = xx y;

        for x: 0..line.count-1
        {
            pos.x = xx x;
            wall[pos.hash] = line[x] == #char "#";

            if line[x] >= #char "0" && line[x] <= #char "7"
            {
                locs[line[x] - #char "0"].x = xx x;
                locs[line[x] - #char "0"].y = xx y;
            }
        }
    }

    for loc, loc_index : locs
    {
        steps : [U16_MAX]u16; for 0..U16_MAX-1 steps[it] = U16_MAX;
        queue : [..]Position;
        array_add(*queue, loc);
        steps[loc.hash] = 0;

        while queue.count
        {
            p := pop(*queue);

            l := p; l.x -= 1;
            r := p; r.x += 1;
            u := p; u.y -= 1;
            d := p; d.y += 1;

            if !wall[l.hash] if steps[p.hash] + 1 < steps[l.hash] { steps[l.hash] = steps[p.hash] + 1; array_add(*queue, l); }
            if !wall[r.hash] if steps[p.hash] + 1 < steps[r.hash] { steps[r.hash] = steps[p.hash] + 1; array_add(*queue, r); }
            if !wall[u.hash] if steps[p.hash] + 1 < steps[u.hash] { steps[u.hash] = steps[p.hash] + 1; array_add(*queue, u); }
            if !wall[d.hash] if steps[p.hash] + 1 < steps[d.hash] { steps[d.hash] = steps[p.hash] + 1; array_add(*queue, d); }
        }

        for other_loc, other_loc_index : locs {
            dist[loc_index][other_loc_index] = steps[other_loc.hash];
        }
    }

    order := u8.[1,2,3,4,5,6,7];

    best_1 := distance(order, dist, false);
    best_2 := distance(order, dist, true);

    for 1..5040-1
    {
        permute(order);
        best_1 = min(best_1, distance(order, dist, false));
        best_2 = min(best_2, distance(order, dist, true));
    }

    return tprint("%", best_1), tprint("%", best_2);
}

#scope_file;

Position :: struct
{
    x : u8;
    y : u8;
    
    #place x;
    hash : u16;
}

distance :: (order: []u8, distances: [8][8]int, back_to_0 : bool) -> int
{
    dist := distances[0][order[0]];

    for 0..order.count-2
        dist += distances[order[it]][order[it+1]];

    if back_to_0 dist += distances[order[order.count-1]][0];

    return dist;
}

permute :: (current : []$T)
{
    j := current.count-2;
    k := current.count-1;

    while current[j] > current[j+1] j -= 1;
    while current[j] > current[k]   k -= 1;

    Swap(*current[j], *current[k]);

    r := current.count-1;
    s := j+1;

    while r > s {
        Swap(*current[r], *current[s]);
        r -= 1;
        s += 1;
    }
}