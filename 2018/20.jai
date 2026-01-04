day20 :: (input: string) -> string, string
{
    SIZE :: 150;
    map := NewArray(SIZE*SIZE, s64);
    for * map it.* = S64_MAX;
    stack : [..] struct { x: s64; y: s64; steps: s64; };
    x, y, steps := SIZE/2, SIZE/2, 0;

    for c: input {
        if c == {
            case "N"; y -= 1; steps += 1; map[y*SIZE+x] = min(map[y*SIZE+x], steps); 
            case "E"; x += 1; steps += 1; map[y*SIZE+x] = min(map[y*SIZE+x], steps); 
            case "S"; y += 1; steps += 1; map[y*SIZE+x] = min(map[y*SIZE+x], steps); 
            case "W"; x -= 1; steps += 1; map[y*SIZE+x] = min(map[y*SIZE+x], steps); 
            case "("; array_add(*stack, { x, y, steps });
            case ")"; it := pop(*stack); x, y, steps = it.x, it.y, it.steps;
            case "|"; it := peek(stack); x, y, steps = it.x, it.y, it.steps;
        }
    }

    part1, part2 := 0;

    for map {
        if it == S64_MAX continue;
        part1 = max(part1, it);
        part2 += ifx it >= 1000 then 1;
    }

    return tprint("%", part1), tprint("%", part2);
}