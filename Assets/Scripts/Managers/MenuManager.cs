using UnityEngine;
using System;

public class MenuManager : MonoBehaviour
{
    public static Action OnGameStart;
    public static Action OnBackToMenu;
    public static Action OnGameOver;

    public MenuAnimations menuAnimations;
    [SerializeField] private GameObject mainMenu;
    [SerializeField] private GameObject gameMenu;
    [SerializeField] private GameObject gameOverMenu;

    private void Update()
    {
        if (GameManager.Instance.IsMenuState() && (Input.GetKeyDown(KeyCode.Return) || Input.GetButtonDown("Jump")))
        {
            OnPressStartButton();
        }
    }
    
    private void HandleGameStart()
    {
        mainMenu.SetActive(false);
        gameMenu.SetActive(true);
    }

    private void HandleGameOver()
    {
        mainMenu.SetActive(false);
        gameMenu.SetActive(false);
        gameOverMenu.SetActive(true);
        OnGameOver?.Invoke();
    }
    
    public void OnPressStartButton()
    {
        GameManager.Instance.SetIntroState();
        HandleGameStart();
        OnGameStart?.Invoke();
    }

     private void OnEnable()
    {
        HealthManager.OnDeath += HandleGameOver;
    }

    private void OnDisable()
    {
        HealthManager.OnDeath -= HandleGameOver;
    }

}
