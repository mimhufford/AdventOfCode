day1 :: (input: string) -> string, string {
    floor := 0;
    first_basement := 0;

    for input {
        floor += ifx it == "(" then 1 else -1;

        if floor < 0 && first_basement == 0
            first_basement = it_index + 1;
    }

    return tprint("%", floor), tprint("%", first_basement);
}