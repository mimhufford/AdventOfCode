day15 :: (input: string) -> string, string
{
    part1, part2 := 0;
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(ram);

    V2 :: struct { x, y: s32; }
    map : [41][41] enum { NONE; FREE; WALL; GOAL; };
    delta :: V2.[{},{0,-1},{0,1},{-1,0},{1,0}];
    left  :: s64.[0, 3, 4, 2, 1];
    right :: s64.[0, 4, 3, 1, 2];
    dir := 1;
    p := V2.{21,21};

    for 1..2000 {
        // move forward
        run(c, dir);
        d := delta[dir];
        s := pop(*c.out);

        // if we hit a wall turn left and loop again
        if s == 0 {
            map[p.y+d.y][p.x+d.x] = .WALL;
            dir = left[dir];
            continue;
        }
        
        // we moved forward
        p.x, p.y += d.x, d.y;
        map[p.y][p.x] = ifx s == 1 then .FREE else .GOAL;

        // do a tentative right movement to see what happens
        dir = right[dir];
        run(c, dir);
        d = delta[dir];
        s = pop(*c.out);

        // if we hit a wall
        if s == 0 {
            map[p.y+d.y][p.x+d.x] = .WALL;
            dir = left[dir];
            continue;
        }

        // we moved forward
        p.x, p.y += d.x, d.y;
        map[p.y][p.x] = ifx s == 1 then .FREE else .GOAL;
    }

    for y: 0..40 {
        for x: 0..40 {
            if x==21 && y==21 { print("@"); continue; }
            if map[y][x] == .NONE print("?");
            if map[y][x] == .FREE print(".");
            if map[y][x] == .WALL print("#");
            if map[y][x] == .GOAL print("O");
        }
        print("\n");
    }
    
    return tprint("%", part1), tprint("%", part2);
}