day3 :: (input: string) -> string, string {
    year_1_santa : Vector2;
    year_2_santa : Vector2;
    year_2_robot : Vector2;

    // @WORKAROUND
    // Jon confirmed this as the workaround until better support for overloaded procedures
    compare_v2 :: #procedure_of_call(operator==(year_1_santa, year_1_santa));

    year_1_houses : Table(Vector2, int, hash_v2, compare_v2);
    year_2_houses : Table(Vector2, int, hash_v2, compare_v2);

    table_add(*year_1_houses, year_1_santa, 0);
    table_add(*year_2_houses, year_2_santa, 0);

    for 0..input.count-1 {
        if input[it] == #char "^" {
            if it % 2 year_2_santa.y += 1;
            else      year_2_robot.y += 1;
            year_1_santa.y += 1;
        } 
        else if input[it] == #char "<" {
            if it % 2 year_2_santa.x -= 1;
            else      year_2_robot.x -= 1;
            year_1_santa.x -= 1;
        }
        else if input[it] == #char ">" {
            if it % 2 year_2_santa.x += 1;
            else      year_2_robot.x += 1;
            year_1_santa.x += 1;
        }
        else {
            if it % 2 year_2_santa.y -= 1;
            else      year_2_robot.y -= 1;
            year_1_santa.y -= 1;
        }   

        table_set(*year_1_houses, year_1_santa, 0);
        table_set(*year_2_houses, year_2_santa, 0);
        table_set(*year_2_houses, year_2_robot, 0);
    }

    return tprint("%", year_1_houses.count), tprint("%", year_2_houses.count);
}

#scope_file

hash_v2 :: (v2 : Vector2) -> u32 {
    // crap - but good enough for this
    return xx (v2.x * 10000 + v2.y);
}