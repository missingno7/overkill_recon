#ifndef SESSION_H
#define SESSION_H
#include "game.h"
#define SESSION_NEW_GAME 0
#define SESSION_COMPLETE_LEVEL 1
#define SESSION_ADVANCE_LEVEL 2
#define SESSION_START_LIFE 3
#define SESSION_FRAME 4
#define SESSION_RESUME_FRAME 5
#define SESSION_QUIT_PROMPT 6
#define SESSION_GAME_OVER 7
#define SESSION_FORCE_GAME_OVER 8
#define SESSION_LOSE_LIFE 9
void run_game_session(word phase, word bp);
#endif
