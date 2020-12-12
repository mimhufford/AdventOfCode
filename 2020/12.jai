day12 :: (input: string) -> string, string
{
    ship1  : Ship;
    input1 := input;

    while input1.count
    {
        ins, val := read_instruction(*input1);
        if ins ==
        {
            case #char "N"; ship1.y -= val;
            case #char "E"; ship1.x += val;
            case #char "S"; ship1.y += val;
            case #char "W"; ship1.x -= val;
            case #char "R"; ship1.dir = cast(Direction)((cast(u8)(ship1.dir) + 4 + (val/90)) % 4);
            case #char "L"; ship1.dir = cast(Direction)((cast(u8)(ship1.dir) + 4 - (val/90)) % 4);
            case #char "F"; if ship1.dir == 
            {
                case .NORTH; ship1.y -= val;
                case .EAST;  ship1.x += val;
                case .SOUTH; ship1.y += val;
                case .WEST;  ship1.x -= val;
            }
        }
    }

    ship2  : Ship;
    input2 := input;

    while input2.count
    {
        ins, val := read_instruction(*input2);
        if ins ==
        {
            case #char "N"; ship2.wy -= val;
            case #char "E"; ship2.wx += val;
            case #char "S"; ship2.wy += val;
            case #char "W"; ship2.wx -= val;
            case #char "R"; for 1..val/90 { y := -ship2.wy; ship2.wy = ship2.wx; ship2.wx = y; }
            case #char "L"; for 1..val/90 { x := -ship2.wx; ship2.wx = ship2.wy; ship2.wy = x; }
            case #char "F"; for 1..val { ship2.x += ship2.wx; ship2.y += ship2.wy; }
        }
    }

    if ship1.x < 0 ship1.x *= -1; if ship1.y < 0 ship1.y *= -1;
    if ship2.x < 0 ship2.x *= -1; if ship2.y < 0 ship2.y *= -1;

    return tprint("%", ship1.x + ship1.y), tprint("%", ship2.x + ship2.y);
}

#scope_file

Ship :: struct
{
    dir : Direction;
    x   : s16;
    y   : s16;
    wx  : s16 = 10;
    wy  : s16 = -1;
}

Direction :: enum u8
{
    EAST;
    SOUTH;
    WEST;
    NORTH;
}

read_instruction :: (s: *string) -> u8, s16
{
    instruction := s.data[0];
    advance(s, 1);

    num : s16;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s, 1);
    }

    if s.count advance(s, 1);

    return instruction, num;
}