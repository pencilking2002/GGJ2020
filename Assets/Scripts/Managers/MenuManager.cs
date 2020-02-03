using UnityEngine;
using System;

public class MenuManager : MonoBehaviour
{
    public static Action OnGameStart;
    public static Action OnBackToMenu;
    public MenuAnimations menuAnimations;
    [SerializeField] private GameObject mainMenu;
    [SerializeField] private GameObject gameMenu;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return) || Input.GetButtonDown("Jump"))
        {
            HandleGameStart();
        }
    }
    
    private void HandleGameStart()
    {
        mainMenu.SetActive(false);
        gameMenu.SetActive(true);
    }
    
    public void HandleStartButton()
    {
        Debug.Log("Start button pressed");
        GameManager.Instance.SetIntroState();
        OnGameStart?.Invoke();
    }

    private void OnEnable() { OnGameStart += HandleGameStart; }
    private void OnDisable() { OnGameStart -= HandleGameStart; }


   
}
