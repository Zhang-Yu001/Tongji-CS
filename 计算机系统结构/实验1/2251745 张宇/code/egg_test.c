#include <stdio.h>

// 定义两个历史时期的成本参数
#define P1_SCARCITY 2      // 物质匮乏时期，每上1层的成本
#define P2_SCARCITY 1      // 物质匮乏时期，每下1层的成本
#define P3_SCARCITY 4      // 物质匮乏时期，每摔破一个鸡蛋的成本

#define P1_LABOR_COST 4    // 人力成本增长时期，每上1层的成本
#define P2_LABOR_COST 1    // 人力成本增长时期，每下1层的成本
#define P3_LABOR_COST 2    // 人力成本增长时期，每摔破一个鸡蛋的成本

// 计算成本的函数
int calculate_cost(int m, int n, int h, int p1, int p2, int p3) {
    return m * p1 + n * p2 + h * p3;
}

int main() {
    int total_floors, resistance_floor;
    printf("请输入比萨塔的总楼层数：");
    scanf("%d", &total_floors);

    printf("请输入鸡蛋的耐摔值楼层（在该楼层及以下不摔破）：");
    scanf("%d", &resistance_floor);

    int attempt_count = 0;   // 总的尝试次数
    int broken_count = 0;    // 摔破的鸡蛋数
    int last_broken = 0;     // 最后一次鸡蛋是否摔破
    int low = 1, high = total_floors;
    int mid;

    // 模拟摔鸡蛋的过程
    while (low < high) {
        attempt_count++;
        mid = (low + high + 1) / 2;

        if (mid > resistance_floor) {
            // 如果当前楼层高于耐摔楼层，鸡蛋会摔破
            broken_count++;
            last_broken = 1;
            high = mid - 1;
        } else {
            // 如果当前楼层低于或等于耐摔楼层，鸡蛋不会摔破
            last_broken = 0;
            low = mid;
        }
        printf("第 %d 次尝试：在第 %d 层扔鸡蛋，鸡蛋%s\n", attempt_count, mid, last_broken ? "摔破" : "没破");
    }

    // 计算上升楼层和下降楼层的总数
    int m = resistance_floor;     // 总共上升的楼层数
    int n = total_floors - resistance_floor; // 总共下降的楼层数
    int h = broken_count;         // 摔破的鸡蛋数

    // 计算两个时期的成本
    int cost_scarcity = calculate_cost(m, n, h, P1_SCARCITY, P2_SCARCITY, P3_SCARCITY);
    int cost_labor_cost = calculate_cost(m, n, h, P1_LABOR_COST, P2_LABOR_COST, P3_LABOR_COST);

    // 输出结果
    printf("总尝试次数：%d\n", attempt_count);
    printf("摔破的鸡蛋数：%d\n", broken_count);
    printf("最后一次鸡蛋%s\n", last_broken ? "摔破" : "没破");

    printf("\n在物质匮乏时期的总成本：%d\n", cost_scarcity);
    printf("在人力成本增长时期的总成本：%d\n", cost_labor_cost);

    return 0;
}
