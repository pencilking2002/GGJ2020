using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OceanScroll : MonoBehaviour
{
    public ScrollingManager scrollingManager;
    public float destroyDelay = 10.0f;

    private void Awake()
    {
        Destroy(gameObject, destroyDelay);
    }
    private void Update()
    {
        //  if (!GameManager.Instance.IsGameplayState())
        //     return;

        var pos = transform.position;
        pos.y += scrollingManager.scrollSpeed * Time.deltaTime;
        transform.position = pos;
    }
}
