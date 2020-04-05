using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioController : MonoBehaviour
{
    [Header("Audio Clips")]
    [SerializeField] private AudioClip menuMusicClip;
    [SerializeField] private AudioClip gameMusicClip;
    [SerializeField] private AudioClip goodDrillClip;
    [SerializeField] private AudioClip badDrillClip;
    [SerializeField] private AudioClip badEmptyDrillClip;

    [Header("Audio Sources")]
    [SerializeField] private AudioSource menuAudioSource;
    [SerializeField] private AudioSource gameAudioSource;

    [SerializeField] private AudioSource drillAudioSource;

    private PlayerController player;

    private void Start()
    {
        menuAudioSource.Play();
        player = GameManager.Instance.player;
    }

    private void Update()
    {
        if (player.IsPlayerWelding())
        {
            if (player.isWeldingOnCurve)
            {
                if (player.moduleCollider.isColliding)
                {
                    if (!drillAudioSource.isPlaying || drillAudioSource.clip != goodDrillClip)
                    {
                        drillAudioSource.clip = goodDrillClip;
                        drillAudioSource.Play();
                    }
                }
                else
                {
                    if (!drillAudioSource.isPlaying || drillAudioSource.clip != badEmptyDrillClip)
                    {
                        drillAudioSource.clip = badEmptyDrillClip;
                        drillAudioSource.Play();
                    }
                }
            }
            else
            {
                if (player.moduleCollider.isColliding)
                {
                    if (!drillAudioSource.isPlaying || drillAudioSource.clip != badDrillClip)
                    {
                        drillAudioSource.clip = badDrillClip;
                        drillAudioSource.Play();
                    }
                }
                else
                {
                    if (!drillAudioSource.isPlaying || drillAudioSource.clip != badEmptyDrillClip)
                    {
                        drillAudioSource.clip = badEmptyDrillClip;
                        drillAudioSource.Play();
                    }
                }
            }
        }
        else if (drillAudioSource.isPlaying)
        {
            drillAudioSource.Stop();
        }
        
        // if (GameManager.Instance.player.IsPlayerWelding() && !GameManager.Instance.player.moduleCollider.isColliding)
        // {
        //     if (!drillAudioSource.isPlaying || drillAudioSource.clip != badEmptyDrillClip)
        //     {
        //         drillAudioSource.Stop();
        //         drillAudioSource.clip = badEmptyDrillClip;
        //         drillAudioSource.Play();
        //     }
        // }
        // else if (GameManager.Instance.player.isWeldingOnCurve)
        // {
        //     if (!drillAudioSource.isPlaying || drillAudioSource.clip == badDrillClip)
        //     {
        //         drillAudioSource.Stop();
        //         drillAudioSource.clip = goodDrillClip;
        //         drillAudioSource.Play();
        //     }
        // }
        // else if (GameManager.Instance.player.IsPlayerWelding())
        // {
        //     if (!drillAudioSource.isPlaying || drillAudioSource.clip == goodDrillClip)
        //     {
        //         drillAudioSource.Stop();
        //         drillAudioSource.clip = badDrillClip;
        //         drillAudioSource.Play();
        //     }
            
        // }
        // else if (drillAudioSource.isPlaying)
        // {
        //     drillAudioSource.Stop();
        // }
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
