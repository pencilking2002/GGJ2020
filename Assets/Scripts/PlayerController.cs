﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class PlayerController : MonoBehaviour
{
    public LineDrawing lineDrawer;
    public PlayerModuleCollider moduleCollider;
    public PlayerCurveManager curveManager;
    [SerializeField] private Transform leftLimit;
    [SerializeField] private Transform rightLimit;

    [SerializeField] private float playerSpeed; //How fast the player moves (not the current speed!)

    [SerializeField] private KeyCode[] moveLeft;
    [SerializeField] private KeyCode[] moveRight;
    [SerializeField] private KeyCode[] weld;

    private Vector3 startPosition;
    private Vector3 nextPosition;
    private Vector3 moveDir; //What direction the player is trying to move in

    private bool canControlPlayer; //Whether the player can control the player character

    [SerializeField] private bool isWelding;
    public bool isWeldingOnCurve;
    
    public static Action OnWeldStart;
    public static Action OnWeldStop;

    private void Awake()
    {
        startPosition = transform.position;
        canControlPlayer = true;
    }

    private void OnEnable()
    {
        OnWeldStart += HandleWeldStart;
        OnWeldStop += HandleWeldStop;
        HealthManager.OnDeath += HandleDeath;
    }

    private void OnDisable()
    {
        OnWeldStart -= HandleWeldStart;
        OnWeldStop -= HandleWeldStop;
        HealthManager.OnDeath -= HandleDeath;
    }

    private void Update()
    {
        if(canControlPlayer == false || !GameManager.Instance.IsGameplayState())
        {
            return;
        }

        for(int i = 0; i < moveLeft.Length; i++)
        {
            var input = Input.GetAxisRaw("Horizontal");
            if (input == -1)
            {
                moveDir = Vector3.left;
                MovePlayer();
            }
        }

        for (int i = 0; i < moveRight.Length; i++)
        {
            var input = Input.GetAxisRaw("Horizontal");
            if(input == 1)
            {
                moveDir = Vector3.right;
                MovePlayer();
            }
        }

        if(Input.GetMouseButtonDown(0) || Input.GetButtonDown("Jump"))
        {
            OnWeldStart?.Invoke();
        }

        if (Input.GetMouseButtonUp(0) || Input.GetButtonUp("Jump"))
        {
            OnWeldStop?.Invoke();
        }

        isWeldingOnCurve = isWelding && curveManager.isNearCurve && moduleCollider.isColliding;
    }

    private void MovePlayer()
    {
        nextPosition = transform.position + (moveDir * playerSpeed * Time.deltaTime);

		if(nextPosition.x > leftLimit.position.x && nextPosition.x < rightLimit.position.x)
		{
			transform.position = nextPosition;
		}
    }

    private void HandleWeldStart()
    {
        isWelding = true;
    }

    public bool IsPlayerWelding()
    {
        return isWelding;
    }

    private void HandleWeldStop()
    {
        isWelding = false;
    }

    private void HandleDeath()
    {
        DisablePlayerController();
    }

    private void EnablePlayerController()
    {
        canControlPlayer = true;
    }

    private void DisablePlayerController()
    {
        canControlPlayer = false;
    }
}
