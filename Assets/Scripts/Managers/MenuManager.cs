using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class MenuManager : MonoBehaviour
{
    public static MenuManager Instance;
    public MenuAnimations menuAnimations;
    public GameObject mainMenu;
    public GameObject gameMenu;

    public static Action OnGameStart;
    public static Action OnBackToMenu;

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            transform.SetParent(null);
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(this);
        }        
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return) || Input.GetButtonDown("Jump"))
        {
            HandleGameStart();
        }
    }

    private void OnEnable()
    {
        OnGameStart += HandleGameStart;
    }

    private void OnDisable()
    {
        OnGameStart -= HandleGameStart;
    }

    public void HandleStartButton()
    {
        Debug.Log("Start button pressed");
        GameManager.Instance.SetIntroState();
        OnGameStart?.Invoke();
    }

    private void HandleGameStart()
    {
        mainMenu.SetActive(false);
        gameMenu.SetActive(true);
    }
}
