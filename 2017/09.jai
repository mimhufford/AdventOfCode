day9 :: (input: string) -> string, string
{
    part1, part2 := 0;

    garbage := false;
    skip := false;
    depth := 0;

    for c: input {
        if skip     { skip = false; continue; }
        if c == "!" { skip = true; continue; }
        if c == ">" { garbage = false; continue; }
        if garbage  { part2 += 1; continue; }
        if c == "{" { depth += 1; continue; }
        if c == "<" { garbage = true; continue; }
        if c == "}" { part1 += depth; depth -= 1; continue; }
    }

    return tprint("%", part1), tprint("%", part2);
}