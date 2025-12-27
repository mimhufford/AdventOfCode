day11 :: (input: string) -> string, string
{
    part1, part2 := 0;
    input[input.count-1] = ",";
    x, y, z := 0;
    
    while input {
        if slice(input, 0, 2) == {
            case "n,"; x -= 1; y += 1; advance(*input, 2);
            case "s,"; x += 1; y -= 1; advance(*input, 2);
            case "ne"; y += 1; z -= 1; advance(*input, 3);
            case "nw"; x -= 1; z += 1; advance(*input, 3);
            case "se"; x += 1; z -= 1; advance(*input, 3);
            case "sw"; y -= 1; z += 1; advance(*input, 3);
        }
        part1 = max(abs(x), abs(y), abs(z));
        part2 = max(part2, part1);
    }

    return tprint("%", part1), tprint("%", part2);
}