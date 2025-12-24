day6 :: (input: string) -> string, string
{
    part1, part2 := 0;

    memory : [16]u8;
    seen : Table(u64, s64);

    for * memory it.* = read_u8(*input);

    key :: (m: []u8) -> u64 {
        result : u64;
        for 0..15 result |= m[it].(u64) << (it * 4);
        return result;
    }

    while true {
        entry, new := find_or_add(*seen, key(memory));

        if new {
            entry.* = part1;
        } else {
            part2 = part1 - entry.*;
            break;
        }
        part1 += 1;

        index, value := 0;
        for memory if it > value then index, value = it_index, it;
        
        memory[index] = 0;
        while value {
            index = (index + 1) % 16;
            memory[index] += 1;
            value -= 1;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}