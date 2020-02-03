using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameSceneManager : MonoBehaviour
{
    public string menuSceneName;
    public string gameSceneName;

    private void LoadScene(string nextSceneName)
    {
        SceneManager.LoadScene(nextSceneName);
    }

    public void ReloadCurrentScene()
    {
        string sceneName = SceneManager.GetActiveScene().name;
        SceneManager.LoadScene(sceneName);
    }
}
