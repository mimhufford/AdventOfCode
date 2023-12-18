day17 :: (input: string) -> string, string
{
    part1 := find_shortest_path(input, 1,  3);
    part2 := find_shortest_path(input, 4, 10);
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Priority_Queue :: struct
{
    v : [..]State;
    p : [..]s64;
}

insert :: (pq: *Priority_Queue, v: State, p: s64)
{
    array_add(*pq.v, v);
    array_add(*pq.p, p);
}

pop :: (pq: *Priority_Queue) -> State, s64
{
    highest_i := 0;
    highest_v := pq.v[0];
    highest_p := pq.p[0];
    for 1..pq.v.count-1
    {
        if pq.p[it] < highest_p
        {
            highest_i = it;
            highest_v = pq.v[it];
            highest_p = pq.p[it];
        }
    }
    array_unordered_remove_by_index(*pq.v, highest_i);
    array_unordered_remove_by_index(*pq.p, highest_i);
    return highest_v, highest_p;
}

find_shortest_path :: (input: string, min_steps: s64, max_steps: s64) -> s64
{
    map := split(trim(input), "\n");
    w := map[0].count;
    h := map.count;

    dist : [..][4]s64;
    queue : Priority_Queue;

    for 0..w*h array_add(*dist, .[S64_MAX, S64_MAX, S64_MAX, S64_MAX]);
    dist[0][0], dist[0][1], dist[0][2], dist[0][3] = 0;
    insert(*queue, .{0, 0, .R}, 0);
    insert(*queue, .{0, 0, .D}, 0);

    while queue.v.count
    {
        s, c := pop(*queue);

        if s.x == w-1 && s.y == h-1 return dist[s.y*w + s.x][s.d];

        dx, dy := dir_to_dx_dy(s.d);
        turns  := dir_to_turns(s.d);
        for t: turns 
        {
            cost := c;
            for 1..max_steps
            {
                x := cast(s64)s.x + it*dx;
                y := cast(s64)s.y + it*dy;
                if x < 0 break;
                if y < 0 break;
                if x >= w break;
                if y >= h break;
                cost += map[y][x] - #char "0";
                if it < min_steps continue;
                if cost < dist[y*w + x][t]
                {
                    dist[y*w + x][t] = cost;
                    found := false;
                    for * queue.v if it.x == x && it.y == y && it.d == t
                    {
                        found = true;
                        queue.p[it_index] = cost;
                        break;
                    }
                    if !found insert(*queue, .{xx x, xx y, t}, cost);
                }
            }
        }
    }

    return 0;
}

State :: struct
{
    x, y : u8;
    d : Direction;
}

dir_to_dx_dy :: (d: Direction) -> s8, s8
{
    if d == .L return -1,  0;
    if d == .R return  1,  0;
    if d == .U return  0, -1;
               return  0,  1;
}

dir_to_turns :: (d: Direction) -> [2]Direction
{
    if d == .L return .[.U, .D];
    if d == .R return .[.U, .D];
    if d == .U return .[.L, .R];
               return .[.L, .R];
}

Direction :: enum u8 { L; R; U; D; }