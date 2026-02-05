day6 :: (input: string) -> string, string {
    lines := split(input, "\n");

    grid1 := NewArray(1000*1000, s64);
    grid2 := NewArray(1000*1000, s64);

    for lines {
        if begins_with(it, "toggle") {
            advance(*it, 7);
            ax, ay, bx, by := parse_parts(it);
            for x : ax..bx {
                for y : ay..by {
                    grid1[y*1000+x] = xx !grid1[y*1000+x];
                    grid2[y*1000+x] += 2;
                }
            }
        } else if begins_with(it, "turn on") {
            advance(*it, 8);
            ax, ay, bx, by := parse_parts(it);
            for x : ax..bx {
                for y : ay..by {
                    grid1[y*1000+x] = 1;
                    grid2[y*1000+x] += 1;
                }
            }
        } else /* turn off */ {
            advance(*it, 9);
            ax, ay, bx, by := parse_parts(it);
            for x : ax..bx {
                for y : ay..by {
                    grid1[y*1000+x] = 0;
                    grid2[y*1000+x] -= 1;
                    if grid2[y*1000+x] < 0 grid2[y*1000+x] = 0;
                }
            }
        }
    }

    lit := 0;
    brightness := 0;

    for x : 0..999 {
        for y : 0..999 {
            if grid1[y*1000+x]  lit += 1;
            brightness += grid2[y*1000+x];
        }
    }

    return tprint("%", lit), tprint("%", brightness);
}

#scope_file

parse_parts :: (s: string) -> (ax: int, ay: int, bx: int, by: int) {
    parts := split(s, " through ");
    a_parts := split(parts[0], ",");
    b_parts := split(parts[1], ",");

    ax := string_to_int(a_parts[0]);
    ay := string_to_int(a_parts[1]);
    bx := string_to_int(b_parts[0]);
    by := string_to_int(b_parts[1]);

    return ax, ay, bx, by;
}