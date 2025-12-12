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

    grid := NewArray((xs.count+2) * (ys.count+2), s64);

    for * grid it.* = 1;

    for * points {
        it.x = table_find_pointer(*x_lookup, it.x).*;
        it.y = table_find_pointer(*y_lookup, it.y).*;
    }

    for 0..points.count-1 {
        p1 := points[it];
        p2 := points[(it+1)%points.count];
        l, r, t, b := min(p1.x, p2.x), max(p1.x, p2.x), min(p1.y, p2.y), max(p1.y, p2.y);
        for y: t..b for x: l..r grid[y * (xs.count+2) + x] = 2;
    }

    queue : [..]Point;
    array_add(*queue, .{0, 0});

    while queue {
        p := pop(*queue);
        if grid[p.y * (xs.count+2) + p.x] == 0 continue;
        grid[p.y * (xs.count+2) + p.x] = 0;
        
        if p.x > 0          && grid[p.y * (xs.count+2) + (p.x - 1)] == 1 array_add(*queue, .{p.x-1, p.y});
        if p.x < xs.count+1 && grid[p.y * (xs.count+2) + (p.x + 1)] == 1 array_add(*queue, .{p.x+1, p.y});
        if p.y > 0          && grid[(p.y - 1) * (xs.count+2) + p.x] == 1 array_add(*queue, .{p.x, p.y-1});
        if p.y < ys.count+1 && grid[(p.y + 1) * (xs.count+2) + p.x] == 1 array_add(*queue, .{p.x, p.y+1});
    }

    for * grid if it.* == 2 then it.* = 1;

    for y: 0..ys.count+1 {
        for x: 0..xs.count+1 {
            if x > 0 grid[y * (xs.count+2) + x] += grid[y * (xs.count+2) + (x-1)];
        }
    }

    for y: 0..ys.count+1 {
        for x: 0..xs.count+1 {
            if y > 0 grid[y * (xs.count+2) + x] += grid[(y-1) * (xs.count+2) + x];
        }
    }
    
    for i: 0..points.count-1 {
        p1 := points[i];
        for j: i+1..points.count-1 {
            p2 := points[j];
            area := (abs(xs[p1.x-1] - xs[p2.x-1]) + 1) * (abs(ys[p1.y-1] - ys[p2.y-1]) + 1);
            part1 = max(part1, area);

            if p1.x == p2.x || p1.y == p2.y || area <= part2 continue;

            l, r, t, b := min(p1.x, p2.x), max(p1.x, p2.x), min(p1.y, p2.y), max(p1.y, p2.y);

            tl := grid[(t-1) * (xs.count+2) + (l-1)];
            tr := grid[(t-1) * (xs.count+2) + (r+0)];
            bl := grid[(b+0) * (xs.count+2) + (l-1)];
            br := grid[(b+0) * (xs.count+2) + (r+0)];

            actual   := tl + br - tr - bl;
            expected := (b-t+1) * (r-l+1);

            if actual != expected continue;

            part2 = area;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}