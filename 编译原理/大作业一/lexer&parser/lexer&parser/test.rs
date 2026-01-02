// test.rs — 示例程序，涵盖绿色规则（0.1–5.1）

fn foo() {
    ;                // 空语句
    return;          // return 无表达式
}

fn max(mut a:i32, mut b:i32) -> i32 {
    if a >= b {
        return a;
    } else {
        return b;
    }
}

fn count_down(mut n:i32) {
    while n != 0 {
        n = n - 1;
    }
}

fn add(mut x:i32, mut y:i32) -> i32 {
    let mut sum:i32;
    let mut temp;
    sum = x + y * (2 + 3);
    temp = foo();
    return sum;
}

fn main() -> i32 {
    let mut result:i32;
    result = add(2, 3);
    return result;
}
