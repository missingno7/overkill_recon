#include "HISTORY.H"
/* Standalone DOS semantic demonstrator, not a game or startup replacement. */
History demo_history;
Position demo_source, demo_targets[2];
volatile Position *demo_selected[2];
int main(void)
{
    unsigned t;
    demo_source.y = 100;
    demo_source.x = 50;
    demo_selected[0] = &demo_targets[0];
    demo_selected[1] = &demo_targets[1];
    history_init(&demo_history, &demo_source);
    for (t = 0; t < 120; ++t) {
        demo_source.y = t;
        demo_source.x = 2 * t;
        history_update(&demo_history, &demo_source, demo_selected, 1, 0);
        if (demo_targets[0].y != (t < 15 ? 108 : t - 15 + 8)) return 1;
        if (demo_targets[0].x != (t < 15 ? 59 : 2 * (t - 15) + 8)) return 2;
        if (demo_targets[1].y != (t < 31 ? 108 : t - 31 + 8)) return 3;
        if (demo_targets[1].x != (t < 31 ? 59 : 2 * (t - 31) + 8)) return 4;
    }
    return 0;
}
