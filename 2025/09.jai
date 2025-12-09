day9 :: (input: string) -> string, string
{
    part1, part2 : s64;

    Point :: struct { x, y : s64; }

    points : [..]Point;
    xs, ys : [..]s64;
    array_reserve(*points, 500);
    array_reserve(*xs, 500);
    array_reserve(*ys, 500);

    while input {
        p := array_add(*points);
        p.x = read_s64(*input); advance(*input);
        p.y = read_s64(*input);
        array_add_if_unique(*xs, p.x);
        array_add_if_unique(*ys, p.y);
    }

    quick_sort(xs, n => n);
    quick_sort(ys, n => n);

    x_lookup : Table(s64, s64);
    y_lookup : Table(s64, s64);

    for xs table_add(*x_lookup, it, it_index+1);
    for ys table_add(*y_lookup, it, it_index+1);

    grid := NewArray((xs.count+2) * (ys.count+2), u8);

    for * grid it.* = ".";

    for 0..points.count-1 {
        p1 := points[it];
        p2 := points[(it+1)%points.count];
        x1 := table_find_pointer(*x_lookup, p1.x).*;
        y1 := table_find_pointer(*y_lookup, p1.y).*;
        x2 := table_find_pointer(*x_lookup, p2.x).*;
        y2 := table_find_pointer(*y_lookup, p2.y).*;
        l, r, t, b := min(x1, x2), max(x1, x2), min(y1, y2), max(y1, y2);
        for y: t..b for x: l..r grid[y * (xs.count+2) + x] = "#";
    }

    queue : [..]Point;
    array_add(*queue, .{0, 0});

    while queue {
        p := pop(*queue);
        if grid[p.y * (xs.count+2) + p.x] == "_" continue;
        grid[p.y * (xs.count+2) + p.x] = "_";
        
        if p.x > 0          && grid[p.y * (xs.count+2) + (p.x - 1)] == "." array_add(*queue, .{p.x-1, p.y});
        if p.x < xs.count+1 && grid[p.y * (xs.count+2) + (p.x + 1)] == "." array_add(*queue, .{p.x+1, p.y});
        if p.y > 0          && grid[(p.y - 1) * (xs.count+2) + p.x] == "." array_add(*queue, .{p.x, p.y-1});
        if p.y < ys.count+1 && grid[(p.y + 1) * (xs.count+2) + p.x] == "." array_add(*queue, .{p.x, p.y+1});
    }

    for i: 0..points.count-1 {
        p1 := points[i];
        x1 := table_find_pointer(*x_lookup, p1.x).*;
        y1 := table_find_pointer(*y_lookup, p1.y).*;

        for j: i+1..points.count-1 {
            p2 := points[j];
            area := (abs(p1.x - p2.x) + 1) * (abs(p1.y - p2.y) + 1);
            part1 = max(part1, area);

            if p1.x == p2.x || p1.y == p2.y || area <= part2 continue;

            x2 := table_find_pointer(*x_lookup, p2.x).*;
            y2 := table_find_pointer(*y_lookup, p2.y).*;
            l, r, t, b := min(x1, x2), max(x1, x2), min(y1, y2), max(y1, y2);

            for y: t..b for x: l..r if grid[y * (xs.count+2) + x] == "_" continue j;

            part2 = area;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}