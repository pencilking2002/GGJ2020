using UnityEngine;

public enum GameState
{
    INTRO,
    START_MENU,
    GAME_PLAY,
    GAME_OVER
}

public partial class GameManager : MonoBehaviour
{
    public static GameManager Instance;

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
}
