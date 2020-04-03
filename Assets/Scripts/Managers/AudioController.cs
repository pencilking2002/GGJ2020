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

        gameAudioSource.Play();

    }

    private void OnEnable()
    {
        MenuManager.OnGameStart += GameStarted;
    }

    private void OnDisable()
    {
        MenuManager.OnGameStart -= GameStarted;
    }
}   
