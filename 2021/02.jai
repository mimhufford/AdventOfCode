day2 :: (data: string) -> string, string
{
    horizontal, depth, aim : u32;

    while data.count
    {
        dir, amt := next_instruction(*data);
        
        if dir == {
            case #char "u"; aim -= amt;
            case #char "d"; aim += amt;
            case #char "f"; horizontal += amt; depth += aim * amt;
        }
    }

    return tprint("%", horizontal * aim), tprint("%", horizontal * depth);
}

next_instruction :: (s: *string) -> dir: u8, amt: u8
{
    dir := s.data[0];

    if dir == {
        case #char "u"; advance(s, 3);
        case #char "d"; advance(s, 5);
        case #char "f"; advance(s, 8);
    }

    amt := s.data[0] - #char "0";

    advance(s, 1);

    return dir, amt;
}