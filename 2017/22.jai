day22 :: (input: string) -> string, string
{
    part1 := 0;

    V2 :: struct { x, y: s32; #overlay(x) hash: u64; }
    State :: enum u8 { CLEAN; WEAKENED; INFECTED; FLAGGED; }
    map : Table(u64, State);

    for y: 0..24 {
        for x: 0..24 {
            coord := V2.{x.(s32), y.(s32)};
            state := input[26 * y + x];
            table_add(*map, coord.hash, ifx state == "#" then .INFECTED);
        }
    }

    dirs :: V2.[{0,-1}, {1,0}, {0,1}, {-1,0}];
    pos := V2.{12, 12};
    dir := 0;

    for 1..10000 {
        state := find_or_add(*map, pos.hash);
        dir += ifx state.* == .INFECTED then 1 else -1;
        dir = (dir + 4) % 4;
        state.* = ifx state.* == .INFECTED then .CLEAN else .INFECTED;
        pos.x, pos.y += dirs[dir].x, dirs[dir].y;
        part1 += ifx state.* == .INFECTED then 1;
    }

    return tprint("%", part1), "";
}