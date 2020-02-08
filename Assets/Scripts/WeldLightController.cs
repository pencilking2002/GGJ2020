using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeldLightController : MonoBehaviour
{
    public GameObject weldParticles;
    public Light spotLight;
    public float normalIntensity = 3.0f;
    public float maxflickerIntensity = 5.0f;
    public float minFlickerIntensity = 1.0f;
    [SerializeField] private bool isFlickering;

    private void Update()
    {
        if (!GameManager.Instance.IsGameplayState())
            return;

        if (GameManager.Instance.player.isWeldingOnCurve)
        {
            spotLight.intensity = Random.Range(minFlickerIntensity, maxflickerIntensity);
        }
        else
        {
            spotLight.intensity = minFlickerIntensity;
        }
    }

    private void StartFlickering()
    {
        isFlickering = true;
        weldParticles.SetActive(true);
    }

    private void StopFlickering()
    {
        isFlickering = false;
        weldParticles.SetActive(false);
        spotLight.intensity = normalIntensity;
    }


    private void OnEnable()
    {
        PlayerController.OnWeldStart += StartFlickering;
        PlayerController.OnWeldStop += StopFlickering;

    }

    private void OnDisable()
    {
        PlayerController.OnWeldStart -= StartFlickering;
        PlayerController.OnWeldStop -= StopFlickering;

    }
}
