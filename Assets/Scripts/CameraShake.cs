///Daniel Moore (Firedan1176) - Firedan1176.webs.com/
///26 Dec 2015
///
///Shakes camera parent object

using UnityEngine;
using System.Collections;

public class CameraShake : MonoBehaviour
{

    [SerializeField] private float shakeAmount = 0.08f;
    private Vector3 initPos;


    void Start()
    {
    }

    private void Update()
    {
        if (!GameManager.Instance.IsGameplayState())
            return;

        if (GameManager.Instance.player.isWeldingOnCurve)
        {
            if (initPos == default)
                initPos = transform.position;

            Vector3 newPos = initPos + Random.insideUnitSphere * shakeAmount;
            newPos.z = initPos.z;
            transform.position = newPos;
        }
        else
        {
           // transform.position = initPos; //Set the local rotation to 0 when done, just to get rid of any fudging stuff.

        }
    }

}