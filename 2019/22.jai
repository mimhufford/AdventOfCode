day22 :: (input: string) -> string, string
{
    part1 := 2019;
    deck := 10007;

    for line: split(trim(input), "\n") {
        if (line[0] == "c") {
            cut := (get(s64, *line) + deck) % deck;
            part1 = (part1 - cut + deck) % deck;
        } else if (line[10] == "i") {
            inc := (get(s64, *line) + deck) % deck;
            part1 = part1 * inc % deck;
        } else {
            part1 = deck - part1 - 1;
        }
    }

    part2: u64;

    {
        pos := to_s128(2020);
        deck := to_s128(119315717514047);
        a := S128_1;
        b := S128_0;

        for < line: split(trim(input), "\n") {
            if (line[0] == "c") {
                cut := to_s128(get(s64, *line));
                _, cut, _ = signed_divide_with_remainder(cut + deck, deck);
                _, pos, _ = signed_divide_with_remainder(pos + cut + deck, deck);
                b += cut;
            } else if (line[10] == "i") {
                inc := to_s128(get(s64, *line));
                inc_inv := mod_pow(inc, deck - S128_2, deck);
                _, pos, _ = signed_divide_with_remainder(inc_inv * pos, deck);
                a, b = a * inc_inv, b * inc_inv;
            } else {
                pos = deck - pos - S128_1;
                a, b = -a, -b + deck - S128_1;
            }
        }

        _, a, _ = signed_divide_with_remainder(a, deck);
        _, b, _ = signed_divide_with_remainder(b, deck);

        rounds := to_s128(101741582076661);
        result := pos * mod_pow(a, rounds, deck) + (mod_pow(a, rounds, deck) - S128_1) * b * mod_pow(a - S128_1, deck - S128_2, deck);
        result += deck;
        _, result, _ = signed_divide_with_remainder(result, deck);
        if result < S128_0 result += deck;

        part2 = result.low;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

S128_0 :: #run to_s128(0);
S128_1 :: #run to_s128(1);
S128_2 :: #run to_s128(2);

mod_pow :: (b: S128, e: S128, m: S128) -> S128 {
    result := S128_1;
    base := b;
    exponent := e;

    while exponent > S128_0 {
        if exponent.low & 1 == 1 {
            _, result, _ = signed_divide_with_remainder(result * base, m);
        }
        _, base, _ = signed_divide_with_remainder(base * base, m);
        exponent >>= 1;
    }

    return result;
}