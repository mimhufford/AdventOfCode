day24 :: (data : string) -> string, string
{
    //                     0    1    2    3    4    5    6    7    8    9   10   11   12   13
    model_number :: s64.[  9,   9,   2,   2,   9,   9,   9,   9,   9,   9,   9,   9,   9,   9];

    // TODO, build this table based on input file, numbers are on every x + 18th rows
    compare      :: s64.[ 11,  13,  11,  10,  -3,  -4,  12,  -8,  -3, -12,  14,  -6,  11, -12];
    divide       :: s64.[  1,   1,   1,   1,  26,  26,   1,  26,  26,  26,   1,  26,   1,  26];
    add          :: s64.[ 14,   8,   4,  10,  14,  10,   4,  14,   1,   6,   0,   9,  13,  12];

    z : s64;
    for 0..13
    {
        x : s64 = xx ((z % 26) + compare[it] != model_number[it]);
        z /= divide[it];
        z *= (25 * x) + 1;
        z += (model_number[it] + add[it]) * x;
        print("%: digit:%, %, %, %\n", it, model_number[it], z%26+compare[it], ifx divide[it] then "Y" else "N", z);
    }

    return tprint("%", ""), tprint("%", "");
}