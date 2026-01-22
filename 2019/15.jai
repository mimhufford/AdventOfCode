day15 :: (input: string) -> string, string
{
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(ram);

    V2 :: struct { x, y: s32; }
    map : [41][41]s64;
    delta :: V2.[{},{0,-1},{0,1},{-1,0},{1,0}];
    start :: V2.{21,21};
    oxygen : V2;
    p := start;
    dir := 1;

    for step: 1..S64_MAX {
        left  :: s64.[0, 3, 4, 2, 1];
        right :: s64.[0, 4, 3, 1, 2];
        move :: () #expand {
            run(c, dir);
            if pop_front(*c.out) == {
                case 0; map[p.y+delta[dir].y][p.x+delta[dir].x] = S64_MAX; dir = left[dir];
                case 1; p.x, p.y += delta[dir].x, delta[dir].y;
                case 2; p.x, p.y += delta[dir].x, delta[dir].y; oxygen = p;
            }
            if step > 1 && p.x == start.x && p.y == start.y break;
        }

        move();
        dir = right[dir];
        move();
    }

    queue : [..]V2;
    array_reserve(*queue, 1000);
    array_add(*queue, oxygen);

    for c: queue {
        for d: 1..4 {
            x, y := c.x + delta[d].x, c.y + delta[d].y;
            if map[y][x] != 0 continue;
            map[y][x] = map[c.y][c.x] + 1;
            array_add(*queue, V2.{x,y});
        }
    }

    part1 := map[start.y][start.x];
    part2 := map[peek(queue).y][peek(queue).x];
    
    return tprint("%", part1), tprint("%", part2);
}