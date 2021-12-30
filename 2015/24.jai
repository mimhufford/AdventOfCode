day24 :: (data: string) -> string, string
{
    packages : [..]s32;

    while data.count array_add(*packages, next_s32(*data));

    return tprint("%", packages), tprint("%", "");
}