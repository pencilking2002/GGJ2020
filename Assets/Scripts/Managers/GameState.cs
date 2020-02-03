using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public partial class GameManager 
{
    public GameState gameState;

     public bool IsIntroState() { return gameState == GameState.INTRO; }
    public bool IsMenuState() { return gameState == GameState.START_MENU; }
    public bool IsGameplayState() { return gameState == GameState.GAME_PLAY; }
    public bool IsGameoverState() { return gameState == GameState.GAME_OVER; }

    public void SetIntroState() { gameState = GameState.INTRO; }
    public void SetMenuState() { gameState = GameState.START_MENU; }
    public void SetGameplayState() { gameState = GameState.GAME_PLAY; }
    public void SetGameoverState() { gameState = GameState.GAME_OVER; }
}
