using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameSceneManager : MonoBehaviour
{
    public static GameSceneManager Instance;

    public string menuSceneName;
    public string gameSceneName;

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
        MenuManager.OnGameStart += HandleGameStart;
    }

    private void OnDisable()
    {
        MenuManager.OnGameStart -= HandleGameStart;
    }

    private void HandleMenu()
    {
        //LoadScene(menuSceneName);
    }

    private void HandleGameStart()
    {
        //LoadScene(gameSceneName);
    }

    private void LoadScene(string nextSceneName)
    {
        SceneManager.LoadScene(nextSceneName);
    }
}
