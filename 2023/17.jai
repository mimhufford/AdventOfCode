day17 :: (input: string) -> string, string
{
    part1 := find_shortest_path(input, 1,  3);
    part2 := find_shortest_path(input, 4, 10);
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

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

    while queue.count
    {
        s, c := pop(*queue);

        if s.x == w-1 && s.y == h-1 return dist[s.y*w + s.x][s.d];

        dx, dy, turns := dir_to_dx_dy_and_turns(s.d);
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
                    insert(*queue, .{xx x, xx y, t}, cost);
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

Direction :: enum u8 { L; R; U; D; }

dir_to_dx_dy_and_turns :: (d: Direction) -> s8, s8, [2]Direction
{
    if d == .L return -1,  0, .[.U, .D];
    if d == .R return  1,  0, .[.U, .D];
    if d == .U return  0, -1, .[.L, .R];
               return  0,  1, .[.L, .R];
}

Priority_Queue :: struct
{
    q : [2000][..]State;
    top, count := 0;
}

insert :: (pq: *Priority_Queue, v: State, p: s64)
{
    array_add(*pq.q[p], v);
    pq.count += 1;
    pq.top = min(p, pq.top);
}

pop :: (pq: *Priority_Queue) -> State, s64
{
    pq.count -= 1;
    best_state := pop(*pq.q[pq.top]);
    best_priority := pq.top;
    while pq.q[pq.top].count == 0 pq.top += 1;
    return best_state, best_priority;
}