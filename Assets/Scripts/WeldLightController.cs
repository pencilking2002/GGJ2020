using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeldLightController : MonoBehaviour
{
    public Light spotLight;
    public float normalIntensity = 3.0f;
    public float maxflickerIntensity = 5.0f;
    public float minFlickerIntensity = 1.0f;
    [SerializeField] private bool isFlickering;

    private void Update()
    {
        if (isFlickering)
        {
            spotLight.intensity = Random.Range(minFlickerIntensity, maxflickerIntensity);
        }
    }

    private void StartFlickering()
    {
        isFlickering = true;
    }

    private void StopFlickering()
    {
        isFlickering = false;
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
