day24 :: (data : string) -> string, string
{
    //                0    1    2    3    4    5    6    7    8    9   10   11   12   13
    digit   :: s64.[  9,   9,   9,   9,   9,   9,   9,   9,   9,   9,   9,   3,   8,   9];

    // TODO, build this table based on input file, numbers are on every x + 18th rows
    target  :: s64.[ 11,  13,  11,  10,  -3,  -4,  12,  -8,  -3, -12,  14,  -6,  11, -12];
    divide  :: s64.[  1,   1,   1,   1,  26,  26,   1,  26,  26,  26,   1,  26,   1,  26];
    add     :: s64.[ 14,   8,   4,  10,  14,  10,   4,  14,   1,   6,   0,   9,  13,  12];

    z : s64;
    for 0..13
    {
        print("%: d:%, t:%, %, %\n", it, digit[it], z%26+target[it], ifx divide[it]==26 then "Y" else "N", z);
        x : s64 = xx ((z % 26) + target[it] != digit[it]);
        z /= divide[it];
        z *= (25 * x) + 1;
        z += (digit[it] + add[it]) * x;
    }

    return tprint("%", z), tprint("%", "");
}