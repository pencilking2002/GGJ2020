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
    public GameSceneManager sceneManager;
    public PlayerController player;
    public HealthManager healthManager;
    [SerializeField] private Vector2 gameResolution = new Vector2(750, 1334);

    private void Awake()
    {
        Screen.SetResolution((int) gameResolution.x, (int) gameResolution.y, true);
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

    private void OnEnable()
    {
        MenuManager.OnGameOver += SetGameoverState;
    }

    private void OnDisable()
    {
        MenuManager.OnGameOver -= SetGameoverState;
    }
}
