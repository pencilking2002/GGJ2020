﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerIntroController : MonoBehaviour
{
    public PlayerController player;
    public float playerFallTime = 1.0f;
    public float fallDistance = 1.0f;

    private void StartPlayerIntro()
    {        
        var targetPos = player.transform.position - new Vector3(0,fallDistance,0);

        LeanTween.move(player.gameObject, targetPos, playerFallTime)
        .setOnComplete(() => {
            GameManager.Instance.SetGameplayState();
        });
    }


    private void OnEnable()
    {
        MenuManager.OnGameStart += StartPlayerIntro;
    }

      private void OnDisable()
    {
        MenuManager.OnGameStart -= StartPlayerIntro;
    }
}
