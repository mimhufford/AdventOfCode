day15 :: (data : string) -> string, string
{
    stride : s64;
    map : [..]s64;
    best : [..]s64;
    visited : [..]bool;

    while data.count
    {
        if !stride && data[0] == #char "\n" stride = xx map.count;

        if data[0] >= #char "0" && data[0] <= #char "9"
        {
            array_add(*best, S64_MAX);
            array_add(*visited, false);
            array_add(*map, data[0] - #char "0");
        }

        advance(*data, 1);
    }

    best[0] = 0;

    index :: (x: s64, y: s64) -> s64 #expand { return y*stride + x; }
    xy    :: (i: s64) -> s64, s64 #expand { return i % stride, i / stride; }

    {
        queue : [..]s64;
        array_add(*queue, 0);

        while queue.count
        {
            dist, i, qi := S64_MAX, 0, 0;
            for queue if best[it] < dist { dist = best[it]; i = it; qi = it_index; }
            array_unordered_remove_by_index(*queue, qi);
            if visited[i] continue;
            visited[i] = true;
            x, y := xy(i);
            if x-1 >= 0     { ni := index(x-1, y); best[ni] = min(best[ni], best[i] + map[ni]); array_add(*queue, ni); }
            if x+1 < stride { ni := index(x+1, y); best[ni] = min(best[ni], best[i] + map[ni]); array_add(*queue, ni); }
            if y-1 >= 0     { ni := index(x, y-1); best[ni] = min(best[ni], best[i] + map[ni]); array_add(*queue, ni); }
            if y+1 < stride { ni := index(x, y+1); best[ni] = min(best[ni], best[i] + map[ni]); array_add(*queue, ni); }
        }
    }

    return tprint("%", best[index(stride-1, stride-1)]), tprint("%", "");
}