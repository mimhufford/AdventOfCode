day24 :: (data: string) -> string, string
{
    packages : [..]s32;

    while data.count array_add(*packages, next_s32(*data));

    goal := 0; for packages goal += it; goal /= 3;

    return tprint("%", packages), tprint("%", goal);
}