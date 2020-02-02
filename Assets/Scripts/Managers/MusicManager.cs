using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MusicManager : MonoBehaviour
{
    public static MusicManager Instance;

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

        AkSoundEngine.SetState("GameState", "Menu");
        PlayMusicMaster();
    }

    private void OnEnable()
    {
        MenuManager.OnGameStart += HandleGameStart;
        MenuManager.OnBackToMenu += HandleBackToMenu;
    }

    private void OnDisable()
    {
        MenuManager.OnGameStart -= HandleGameStart;
        MenuManager.OnBackToMenu -= HandleBackToMenu;
    }

    private void PlayMusicMaster()
    {
        AkSoundEngine.PostEvent("PlayMusicMaster", gameObject);
    }

    private void HandleGameStart()
    {
        AkSoundEngine.SetState("GameState", "Game");
    }

    private void HandleBackToMenu()
    {
        AkSoundEngine.SetState("GameState", "Menu");
    }

}
