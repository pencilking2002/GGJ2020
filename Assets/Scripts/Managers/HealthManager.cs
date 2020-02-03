using UnityEngine;
using System;

public class HealthManager : MonoBehaviour
{
    public PlayerController playerController;
    public PlayerCurveManager playerCurveManager;

    [SerializeField] private GameObject SliderBar;
    private RectTransform sliderBarRect;
    private float sliderBarMaxWidth;
    private float sliderBarHeight;
    private float sliderBarNewWidth;

    [SerializeField] private float maxHealth;
    public float currentHealth;
    public bool losingHealth;
    [SerializeField] private float gainHealthAmount;
    [SerializeField] private float gainHealthTimeInterval;
    private float gainHealthTimeRef;
    [SerializeField] private float loseHealthAmount;
    [SerializeField] private float loseHealthTimeInterval;
    private float loseHealthTimeRef;

	public static Action OnDeath;

    private void Awake()
    {
        sliderBarRect = SliderBar.GetComponent<RectTransform>();
        sliderBarMaxWidth = sliderBarRect.rect.width;
        sliderBarHeight = sliderBarRect.rect.height;

        currentHealth = maxHealth;
        gainHealthTimeRef = Time.time;
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
        if(!GameManager.Instance.IsGameplayState())
        {
            return;
        }

        if (CheckIsWelding() == true)
        {
            losingHealth = false;
        }
        else
        {
            losingHealth = true;
        }

        if (losingHealth == true && (Time.time - loseHealthTimeRef) >= loseHealthTimeInterval)
        {
            LoseHealth();
            loseHealthTimeRef = Time.time;
        }

        if(losingHealth == false && (Time.time - gainHealthTimeRef) >= gainHealthTimeInterval)
        {
            GainHealth();
            gainHealthTimeRef = Time.time;
            Debug.Log("Gaiing health");
        }
    }

    private bool CheckIsWelding()
    {
        bool check;

        if(playerController.IsPlayerWelding() == true && playerCurveManager.isNearCurve == true)
        {
            check = true;
        }
        else
        {
            check = false;
        }


        return check;
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

        currentHealth = newHealth;
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
