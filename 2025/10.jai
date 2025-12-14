day10 :: (input: string) -> string, string
{
    part1, part2 : s64;

    machines := parse_machines(input);

    for m: machines {
        part1 += fewest_light_presses(m);
        part2 += fewest_count_presses(m);
        // part2 += fewest_count_presses_using_maths_i_dont_fully_understand_yet(m);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Button :: struct {
    mask: u16;
    indices: [..]s64;
}

Machine :: struct {
    light_goal : u16;
    buttons : [..]Button;
    joltages : [..]s16;
}

fewest_light_presses :: (m: Machine) -> s64 {
    // It's toggling, so we only need to press each button once
    // Go through bit combinations in increasing number of bits
    // Press any button whose bit is set, then check the result
    // e.g. for 3 buttons try 001, 010, 100, 011, 101, 110, 111
    for presses: 1..m.buttons.count {
        x := cast(u16, 1) << presses - 1;

        while x < cast(u16, 1) << m.buttons.count {
            lights : u16;

            for 0..m.buttons.count-1 {
                if x & (cast(u16, 1) << it) == 0 continue;
                lights ^= m.buttons[it].mask;
            }

            if lights == m.light_goal return presses;

            // "gosper's hack"
            u := x & (~x + 1);
            v := x + u;
            x = v + (((v ^ x) / u) >> 2);
        }
    }

    return 0;
}

fewest_count_presses :: (m: Machine) -> s64 {

    inner :: (m: Machine, joltages: []s16, cache: *Table(string, s64)) -> s64 {
        key := tprint("%", joltages);
        cached_result := table_find_pointer(cache, key);
        if cached_result return cached_result.*;

        done := true;
        for joltages if it { done = false; break; }
        if done return 0;

        goal : u16;
        for joltage, index: joltages {
            if joltage % 2 == 0 continue;
            goal |= cast(u16, 1) << index;
        }

        combinations := 1 << m.buttons.count;

        best := 1_000_000;

        for press_mask: 0..combinations-1 {
            parity : u16;

            for index: 0..m.buttons.count-1 {
                if press_mask & (1 << index) == 0 continue;
                parity ^= m.buttons[index].mask;
            }

            if goal != parity continue;

            new_joltages := array_copy(joltages);

            for index: 0..m.buttons.count-1 {
                if press_mask & (1 << index) == 0 continue;
                for m.buttons[index].indices {
                    new_joltages[it] -= 1;
                    if new_joltages[it] < 0 continue press_mask;
                }
            }

            for * new_joltages it.* /= 2;

            best = min(best, popcount(press_mask) + 2 * inner(m, new_joltages, cache));
        }

        table_add(cache, key, best);
        return best;
    }

    cache : Table(string, s64);
    result := inner(m, m.joltages, *cache);
    deinit(*cache);
    return result;
}

fewest_count_presses_using_maths_i_dont_fully_understand_yet :: (m: Machine) -> s64 {
    // print("%\n", m.joltages);
    // for m.buttons print("- %\n", it.indices);
    // print("\n");

    // create the augmented matrix
    rows := m.joltages.count;
    cols := m.buttons.count + 1;
    matrix := NewArray(rows * cols, float);

    // fill the joltage column
    for row: 0..rows-1 {
        matrix[row * cols + cols - 1] = m.joltages[row].(float);
    }

    // fill the coefficients
    for row: 0..rows-1 {
        for col: 0..cols-2 {
            for m.buttons[col].indices {
                if it != row continue;
                matrix[row * cols + col] = 1;
                break;
            }
        }
    }

    swap_rows :: (a: s64, b: s64) #expand {
        for col: 0..cols-1 swap(*matrix[a * cols + col], *matrix[b * cols + col]);
    } 

    print_matrix :: () #expand {
        for row: 0..rows-1 {
            for col: 0..cols-2 {
                value := matrix[row * cols + col];
                if value >= 0 print("  %", value);
                else print(" %", value);
            }
            print("| %\n", matrix[row * cols + cols - 1]);
        }
        print("\n");
    }

    // print("AUGMENTED\n");
    // print_matrix();

    pivot_row := 0;

    // apply guass elimination to bring to reduce row echelon form
    for col: 0..cols-2 {
        if pivot_row >= rows break;

        found_pivot := false;

        // make top entry in this column a 1
        for row: pivot_row..rows-1 {
            if matrix[row * cols + col] == 0 continue;
            found_pivot = true;
            // print("swap r% with r%\n", pivot_row, row);
            swap_rows(pivot_row, row);
            mult := 1 / matrix[pivot_row * cols + col];
            for ci: 0..cols-1 matrix[pivot_row * cols + ci] *= mult;
            break;
        }
        
        if !found_pivot {
            // print("UNABLE TO FIND A PIVOT FOR COL %\n", col);
            continue;
        }

        // print("TOP ENTRY FOR COL % IS 1\n", col);
        // print_matrix();

        // perform row operations to make all other rows in this column 0
        for row: 0..rows-1 {
            if row == pivot_row continue; // don't change the pivot value
            if matrix[row * cols + col] == 0 continue; // nothing to do
            // print("need to change row % for col %\n", row, col);
            value := matrix[row * cols + col];
            for ci: 0..cols-1 {
                matrix[row * cols + ci] -= value * matrix[pivot_row * cols + ci];
            }
        }

        // print("ALL OTHER VALUES 0 FOR COL %\n", col);
        // print_matrix();

        pivot_row += 1;
    }

    for * matrix it.* = floor(it.* + 0.5);
    // print("RREF\n");
    // print_matrix();
    // print("\n");

    return 0;
}

parse_machines :: (input: string) -> []Machine {
    machines : [..]Machine;

    while input {
        m := array_add(*machines);

        // light indicators
        advance(*input); // skip "["
        light_goal := read_up_to(*input, "]");
        for i: 0..light_goal.count-1 {
            index := light_goal.count - i - 1;
            if light_goal[index] != "#" continue;
            m.light_goal |= cast(u16, 1) << index;
        }
        advance(*input, 2); // skip "] "

        // buttons
        while true {
            if input[0] != "(" break;
            advance(*input); // skip "("
            button := array_add(*m.buttons);
            while input[0] != ")" {
                index := read_u16(*input);
                button.mask |= cast(u16, 1) << index;
                array_add(*button.indices, index);
                if input[0] == "," advance(*input);
            }
            advance(*input, 2); // skip ") "
        }

        // joltages
        advance(*input); // skip "{"
        while input[0] != "}" {
            array_add(*m.joltages, read_s16(*input));
            if input[0] == "," advance(*input);
        }
        advance(*input, 2); // skip "}\n"
    }

    return machines;
}