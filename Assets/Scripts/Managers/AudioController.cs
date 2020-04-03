using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioController : MonoBehaviour
{
    [SerializeField] private AudioClip menuMusicClip;
    [SerializeField] private AudioClip gameMusicClip;

    private AudioSource audioSource;

    private void Start()
    {
        audioSource = GetComponent<AudioSource>();
        audioSource.clip = menuMusicClip;
        audioSource.loop = true;
        audioSource.Play();
    }
}   
