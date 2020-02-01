using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameSceneManager : MonoBehaviour
{
    public static GameSceneManager Instance;

    public Scene menuScene;
    public Scene gameScene;

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
        MainMenuManager.OnGameStart += HandleGameStart;
    }

    private void OnDisable()
    {
        MainMenuManager.OnGameStart -= HandleGameStart;
    }

    private void HandleMenu()
    {
        LoadScene(menuScene);
    }

    private void HandleGameStart()
    {
        LoadScene(gameScene);
    }

    private void LoadScene(Scene nextScene)
    {
        SceneManager.LoadScene(nextScene.name);
    }
}
