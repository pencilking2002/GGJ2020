using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class MenuManager : MonoBehaviour
{
    public static MenuManager Instance;

    public GameObject mainMenu;
    public GameObject gameMenu;
    [SerializeField] CanvasGroup ruptureLogo;

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
        
        AnimateLogo();
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return) || Input.GetButtonDown("Jump"))
        {
            HandleGameStart();
        }
    }

    private void AnimateLogo()
    {
        ruptureLogo.alpha = 0.0f;
        LeanTween.delayedCall(1.0f, () => {
            var targetPos = ruptureLogo.transform.position;
            ruptureLogo.transform.position -= Vector3.up * 20.0f;

            LeanTween.move(ruptureLogo.gameObject, targetPos, 1.0f).setEaseOutExpo();
            LeanTween.alphaCanvas(ruptureLogo, 0.8f, 1.0f);
        });
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
