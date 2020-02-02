using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public PlayerController player;
    public float playerTrackDelay = 0.5f;
    public float camPanDamp = 8.0f;
    private Vector3 refVel;

    private void LateUpdate()
    {
        if (Time.timeSinceLevelLoad > playerTrackDelay)
        {
            var targetCamPos = transform.position;
            targetCamPos.y = player.transform.position.y;
            transform.position = Vector3.SmoothDamp(transform.position, targetCamPos,ref refVel, camPanDamp);
        }
    }
}
