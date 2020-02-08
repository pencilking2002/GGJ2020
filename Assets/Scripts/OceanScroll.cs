using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OceanScroll : MonoBehaviour
{
    public ScrollingManager scrollingManager;
    public float stopAfter = 10.0f;

    private void Awake()
    {

    }

    private void Update()
    {
         if (GameManager.Instance.IsMenuState() || Time.timeSinceLevelLoad > stopAfter)
            return;

        var pos = transform.position;
        pos.y += scrollingManager.scrollSpeed * Time.deltaTime;
        transform.position = pos;
    }
}
