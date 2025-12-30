day22 :: (input: string) -> string, string
{
    part1, part2 := 0;

    dirs :: V2.[{0,-1}, {1,0}, {0,1}, {-1,0}];

    map, pos, dir := initialise(input);

    for 1..10000 {
        state := find_or_add(*map, pos.hash);
        if state.* == {
            case .CLEAN;    dir -= 1; state.* = .INFECTED; part1 += 1;
            case .INFECTED; dir += 1; state.* = .CLEAN;
        }
        dir = (dir + 4) % 4;
        pos.x, pos.y += dirs[dir].x, dirs[dir].y;
    }

    map, pos, dir = initialise(input);
    
    for 1..10000000 {
        state := find_or_add(*map, pos.hash);
        if state.* == {
            case .CLEAN;    dir -= 1; state.* = .WEAKENED;
            case .WEAKENED;           state.* = .INFECTED;  part2 += 1;
            case .INFECTED; dir += 1; state.* = .FLAGGED;
            case .FLAGGED;  dir += 2; state.* = .CLEAN;
        }
        dir = (dir + 4) % 4;
        pos.x, pos.y += dirs[dir].x, dirs[dir].y;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

V2 :: struct { x, y: s32; #overlay(x) hash: u64; }
State :: enum u8 { CLEAN; WEAKENED; INFECTED; FLAGGED; }

initialise :: (input: string) -> Table(u64, State), V2, s64 {
    map : Table(u64, State);

    for y: 0..24 {
        for x: 0..24 {
            coord := V2.{x.(s32), y.(s32)};
            state := input[26 * y + x];
            table_add(*map, coord.hash, ifx state == "#" then .INFECTED);
        }
    }

    return map, V2.{12, 12}, 0;
}