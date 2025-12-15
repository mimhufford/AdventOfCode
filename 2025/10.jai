day10 :: (input: string) -> string, string
{
    part1, part2 : s64;

    machines := parse_machines(input);
    
    wrong := 0;

    for m: machines {
        part1 += fewest_light_presses(m);
        slow := fewest_count_presses(m);
        fast := fewest_count_presses_using_maths_i_dont_fully_understand_yet(m, false);
        if slow != fast {
            wrong += 1;
            print("ERROR: %) % - % vs %\n", it_index, m.joltages, slow, fast);
            fewest_count_presses_using_maths_i_dont_fully_understand_yet(m, true);
        } else {
            print("OK: %) % - % vs %\n", it_index, m.joltages, slow, fast);
        }
        part2 += slow;
    }

    print("Amount wrong: %\n", wrong);

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

    inner :: (m: Machine, joltages: []s16, cache: *Table(u32, s64)) -> s64 {
        key := get_hash(joltages);
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

    cache : Table(u32, s64);
    result := inner(m, m.joltages, *cache);
    deinit(*cache);
    return result;
}

fewest_count_presses_using_maths_i_dont_fully_understand_yet :: (m: Machine, debug: bool) -> s64 {
    if debug {
        print("%\n", m.joltages);
        for m.buttons print("- %\n", it.indices);
        print("\n");
    }

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

    // Before doing any work we can check if any joltage is changed by all
    // buttons. If it is then the minimum must just be that joltage value.
    for row: 0..rows-1 {
        for col: 0..cols-2 {
            if matrix[row * cols + col] == 0 continue row;
        }
        return matrix[row * cols + cols - 1].(s64);
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

    if debug {
        print("AUGMENTED\n");
        print_matrix();
    }

    pivot_row := 0;

    // apply guass elimination to bring to reduce row echelon form
    for col: 0..cols-2 {
        if pivot_row >= rows break;

        found_pivot := false;

        // make top entry in this column a 1
        for row: pivot_row..rows-1 {
            if values_are_close(matrix[row * cols + col], 0) continue;
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

    if debug {
        print("RREF\n");
        print_matrix();
    }

    // TODO: explain
    found_answer_easily := true;
    for col: 0..cols-2 {
        col_total := 0.0;
        for row: 0..rows-1 {
            value := matrix[row * cols + col];
            col_total += value;
            if value < 0 || value > 1 {
                found_answer_easily = false;
                break col;
            }
        }
        if col_total == 1 continue;
        found_answer_easily = false;
        break;
    }

    if found_answer_easily {
        col_total := 0.0;
        for row: 0..rows-1 col_total += matrix[row * cols + cols - 1];
        return col_total.(s64);
    }

    // TODO: identify free variables and try values for them

    free_variables : [..]s64;
    for col: 0..cols-2 {
        one_count   := 0;
        other_count := 0;
        for row: 0..rows-1 {
            if matrix[row * cols + col] == 1 { one_count   += 1; continue; }
            if matrix[row * cols + col] != 0 { other_count += 1; continue; }
        }
        if one_count == 1 && other_count == 0 continue;
        array_add(*free_variables, col);
    }

    if debug print("Free variables: %\n", free_variables);

    best := S64_MAX;

    // TODO: I don't know how to work upper bounds on free variables yet
    for free_press_amount: 0..40 { // TODO: needs to be per free variable
        press_counts : [..]s64;
        defer array_free(press_counts);

        // calculate how many presses of each button based on free press amounts
        for col: 0..cols-2 {
            if array_find(free_variables, col) {
                array_add(*press_counts, free_press_amount);
                continue;
            }

            pivot_row := 0;
            for row: 0..rows-1 {
                if matrix[row * cols + col] == 1 {
                    pivot_row = row;
                    break;
                }
            }

            target := matrix[pivot_row * cols + cols - 1];
            presses := target;
            for free_variables {
                presses -= free_press_amount * matrix[pivot_row * cols + it];
            }

            array_add(*press_counts, presses.(s64));
        }

        // print("%\n", press_counts);
        total_presses := 0;
        for press_counts total_presses += it;

        if total_presses >= best continue;

        // check counts are valid
        for press_counts {
            if it >= 0 continue;
            continue free_press_amount;
        }

        // check solutions
        for row: 0..rows-1 {
            expected := matrix[row * cols + cols - 1];
            actual := 0.0;
            for col: 0..cols-2 {
                actual += press_counts[col] * matrix[row * cols + col];
            }
            if !values_are_close(expected, actual) {
                continue free_press_amount;
            }
        }

        best = total_presses;
    }

    if debug print("\n");
    return best;
}

/*

AUGMENTED
  0  0  0  0  1  1| 3
  0  1  0  0  0  1| 5
  0  0  1  1  1  0| 4
  1  1  0  1  0  0| 7

RREF
  a  b  c  d  e  f
  1  0  0  1  0 -1| 2
  0  1  0  0  0  1| 5
  0  0  1  1  0 -1| 1
  0  0  0  0  1  1| 3
           ^     ^
"Free" variables are e and f

Rows in equation form
  a + d - f = 2
  b + f     = 5
  c + d - f = 1
  e + f     = 3

Rearrange
  a = 2 - d + f
  b = 5 - f
  c = 1 - d + f
  e = 3 - f

// Plugging in some test values for the free variables at this point
// allows me to push all the new RREF "buttons" and check it works out
// but I don't yet have any bounds on the free variables except >= 0...
  for example:
  d = 3, f = 2
  so
  a = 1, b = 3, c = 0, e = 1

We know buttons press counts are >= 0, so
  2 - d + f >= 0
  5 - f     >= 0
  1 - d + f >= 0
  3 - f     >= 0

Rearrange
  d - f <= 2
  f     <= 5
  d - f <= 1
  f     <= 3

  take max so f is 0..5

  d >= 0
  d <= 2 + f
  d <= 1 + f

  take max so d is 0..7?

So
  f is between 0 and ?
  d is between 0 and ?

*/

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