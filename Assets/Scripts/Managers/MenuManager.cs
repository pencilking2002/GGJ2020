using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class MenuManager : MonoBehaviour
{
    public static MenuManager Instance;

    public static Action OnGameStart;

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
        OnGameStart?.Invoke();
    }

    private void HandleGameStart()
    {
        
    }
}
