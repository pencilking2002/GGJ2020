using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class HealthManager : MonoBehaviour
{
    public static HealthManager Instance;
    public PlayerController playerController;
    public PlayerCurveManager playerCurveManager;

    [SerializeField] private GameObject SliderBar;
    private RectTransform sliderBarRect;
    private float sliderBarMaxWidth;
    private float sliderBarHeight;
    private float sliderBarNewWidth;

    [SerializeField] private float maxHealth;
    private float currentHealth;
    private bool losingHealth;
    [SerializeField] private float gainHealthAmount;
    [SerializeField] private float gainHealthTimeInterval;
    private float gainHealthTimeRef;
    [SerializeField] private float loseHealthAmount;
    [SerializeField] private float loseHealthTimeInterval;
    private float loseHealthTimeRef;

	public static Action OnDeath;

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

        sliderBarRect = SliderBar.GetComponent<RectTransform>();
        sliderBarMaxWidth = sliderBarRect.rect.width;
        sliderBarHeight = sliderBarRect.rect.height;

        currentHealth = maxHealth;
        losingHealth = false;
        loseHealthTimeRef = Time.time;
    }

    private void OnEnable()
	{
        OnDeath += HandleDeath;
	}

    private void OnDisable()
	{
        OnDeath -= HandleDeath;
	}

    private void Update()
    {
        if(losingHealth == true && (Time.time - loseHealthTimeRef) >= loseHealthTimeInterval)
        {
            LoseHealth();
            loseHealthTimeRef = Time.time;
        }

        if(losingHealth == false && (Time.time -gainHealthTimeRef) >= gainHealthTimeInterval)
        {
            GainHealth();
        }

        if(CheckIsWelding())
        {
            losingHealth = true;
        }
        else
        {
            losingHealth = false;
        }
    }

    private bool CheckIsWelding()
    {
        return  playerController.IsPlayerWelding() && playerCurveManager.isNearCurve;    
    }

    private void HandleStartLosingHealth()
    {
        loseHealthTimeRef = Time.time;
        losingHealth = false;
    }

    private void GainHealth()
    {
        float newHealth = currentHealth + gainHealthAmount;

        if(newHealth > maxHealth)
        {
            newHealth = maxHealth;
        }

        sliderBarNewWidth = (currentHealth / maxHealth) * sliderBarMaxWidth;
        sliderBarRect.sizeDelta = new Vector2(sliderBarNewWidth, sliderBarHeight);
    }

    private void LoseHealth()
    {
        currentHealth -= loseHealthAmount;

        if(currentHealth > 0)
        {
            sliderBarNewWidth = (currentHealth / maxHealth) * sliderBarMaxWidth;
            sliderBarRect.sizeDelta = new Vector2(sliderBarNewWidth, sliderBarHeight);
        }
        else
        {
            OnDeath?.Invoke();
        }
    }
   

    private void HandleStopLosingHealth()
    {
        losingHealth = true;
    }

    private void HandleDeath()
    {

    }


}
