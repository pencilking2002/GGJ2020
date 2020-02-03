using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MenuAnimations : MonoBehaviour
{
    [SerializeField] CanvasGroup ruptureLogo;
    [SerializeField] CanvasGroup startButton;
    [SerializeField] float animDelay = 1.0f;
    [SerializeField] float animTime = 1.0f;
    [SerializeField] float logoMoveDistance = 20.0f;
    private void Awake()
    {
        InitMenuAnimSequence();
    }
    private void InitMenuAnimSequence()
    {
        ruptureLogo.alpha = 0.0f;
        startButton.alpha = 0.0f;

        LeanTween.delayedCall(animDelay, () => {

            // Fade in and move the logo up
            var targetPos = ruptureLogo.transform.position;
            ruptureLogo.transform.position -= Vector3.up * logoMoveDistance;

            LeanTween.alphaCanvas(ruptureLogo, 1.0f, animTime * 0.6f).setEaseOutCubic();
            LeanTween.move(ruptureLogo.gameObject, targetPos, animTime).setEaseOutCubic().setOnComplete(() => {
                // Fade in the start button
                LeanTween.alphaCanvas(startButton, 1.0f, animTime * 0.2f);
            });


        });
        
    }
}
