day15 :: (input: string) -> string, string
{
    part1, part2 := 0;
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(ram);

    V2 :: struct { x, y: s32; }
    map : [41][41] enum { NONE; FREE; WALL; GOAL; };
    start :: V2.{21,21};
    oxygen : V2;
    p := start;
    dir := 1;

    for step: 1..S64_MAX {
        delta :: V2.[{},{0,-1},{0,1},{-1,0},{1,0}];
        left  :: s64.[0, 3, 4, 2, 1];
        right :: s64.[0, 4, 3, 1, 2];
        move :: () #expand {
            run(c, dir);
            if pop(*c.out) == {
                case 0; map[p.y+delta[dir].y][p.x+delta[dir].x] = .WALL; dir = left[dir];
                case 1; p.x, p.y += delta[dir].x, delta[dir].y; map[p.y][p.x] = .FREE;
                case 2; p.x, p.y += delta[dir].x, delta[dir].y; map[p.y][p.x] = .GOAL; oxygen = p;
            }
            if step > 1 && p.x == start.x && p.y == start.y break;
        }

        move();
        dir = right[dir];
        move();
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