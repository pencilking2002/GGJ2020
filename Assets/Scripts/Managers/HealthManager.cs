using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class HealthManager : MonoBehaviour
{
    public static HealthManager Instance;

    [SerializeField] private GameObject SliderBar;
    private RectTransform sliderBarRect;
    private float sliderBarWidth;
    private float sliderBarHeight;
    private float sliderBarNewWidth;
    private float sliderBarNewHeight;

    [SerializeField] private float maxHealth;
    private float health;
    private bool losingHealth;
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
        sliderBarWidth = sliderBarRect.rect.width;
        sliderBarHeight = sliderBarRect.rect.height;

        losingHealth = true;
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
    }

    private void HandleStartLosingHealth()
    {
        loseHealthTimeRef = Time.time;
        losingHealth = false;
    }

    private void LoseHealth()
    {
        health -= loseHealthAmount;
        sliderBarRect.sizeDelta = new Vector2();
    }
   

    private void HandleStopLosingHealth()
    {
        losingHealth = true;
    }

    private void HandleDeath()
    {

    }


}
