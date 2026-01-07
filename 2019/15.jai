day15 :: (input: string) -> string, string
{
    part1, part2 := 0;
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(ram);

    V2 :: struct { x, y: s32; }
    map : [41][41] enum { NONE; FREE; WALL; GOAL; };
    p := V2.{21,21};

    // IDEA : use 1 computer and do a wall following algorithm
    // IDEA : work out which memory stores x and y, and fuck with it to do a BFS 
    for 1..1000000 {
        // north 1, south 2, west 3, east 4
        delta :: V2.[{0,-1},{0,1},{-1,0},{1,0}];
        dir := (random_get() % 4 + 1).(s64);
        d := delta[dir-1];
        run(c, dir);
        if pop(*c.out) == {
            case 0; map[p.y+d.y][p.x+d.x] = .WALL;
            case 1; p.x, p.y += d.x, d.y; map[p.y][p.x] = .FREE;
            case 2; p.x, p.y += d.x, d.y; map[p.y][p.x] = .GOAL;
        }
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