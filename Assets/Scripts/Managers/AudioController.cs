using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioController : MonoBehaviour
{
    [SerializeField] private AudioClip menuMusicClip;
    [SerializeField] private AudioClip gameMusicClip;

    [SerializeField] private AudioSource menuAudioSource;
    [SerializeField] private AudioSource gameAudioSource;

    private void Start()
    {
        menuAudioSource.Play();
    }

    private void GameStarted()
    {
        var seq = LeanTween.sequence();
        seq.append(LeanTween.value(1.0f, 0.0f, 3.0f).setOnUpdate(val => {
            menuAudioSource.volume = val;
        }));        

        seq.append(() => {
            menuAudioSource.Stop();
        });
        gameAudioSource.volume = 1.0f;
        gameAudioSource.Play();

    }

    private void GameOver()
    {
        var seq = LeanTween.sequence();
        seq.append(LeanTween.value(1.0f, 0.0f, 1.0f).setOnUpdate(val => {
            gameAudioSource.volume = val;
        }));        

        seq.append(() => {
            gameAudioSource.Stop();
        });
        menuAudioSource.volume = 1.0f;
        menuAudioSource.Play();
    }

    private void OnEnable()
    {
        MenuManager.OnGameStart += GameStarted;
        MenuManager.OnGameOver += GameOver;
    }


    private void OnDisable()
    {
        MenuManager.OnGameStart -= GameStarted;
        MenuManager.OnGameOver -= GameOver;
    }
}   
