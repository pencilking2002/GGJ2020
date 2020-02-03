using UnityEngine;

public enum GameState
{
    INTRO,
    START_MENU,
    GAME_PLAY,
    GAME_OVER
}

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;
    public GameState gameState;

    [Header("Component References")]
    public MenuManager menuManager;
    public PlayerController player;

    private void Awake()
    {
        Screen.SetResolution(750, 1334, true);

       SetMenuState();

        if (Instance == null)
        {
            Instance = this;
        }
        else
        {
            Instance = null;
            Destroy(gameObject);
        }

    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            Application.Quit();
        }
    }

    public bool IsIntroState() { return gameState == GameState.INTRO; }
    public bool IsMenuState() { return gameState == GameState.START_MENU; }
    public bool IsGameplayState() { return gameState == GameState.GAME_PLAY; }
    public bool IsGameoverState() { return gameState == GameState.GAME_OVER; }

    public void SetIntroState() { gameState = GameState.INTRO; }
    public void SetMenuState() { gameState = GameState.START_MENU; }
    public void SetGameplayState() { gameState = GameState.GAME_PLAY; }
    public void SetGameoverState() { gameState = GameState.GAME_OVER; }


}
