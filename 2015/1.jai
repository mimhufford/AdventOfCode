day1 :: (input: string) -> string, string {
    floor := 0;
    first_basement := 0;

    for 0..input.count-1 {
        if input[it] == #char "("
            floor += 1;
        else
            floor -= 1;

        if floor < 0 && first_basement == 0
            first_basement = it + 1;
    }

    return tprint("%", floor), tprint("%", first_basement);
}