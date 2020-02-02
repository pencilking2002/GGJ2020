using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrollingManager : MonoBehaviour
{
    public Collider[] modules;
    public float scrollSpeed = 5.0f;
    public float cutoffPointY = 15.0f;
    public Camera cam;


    private void Update()
    {
        //var cutoffPoint = cam.ScreenToWorldPoint(new Vector3(0.5f, cam.pixelHeight, 10));
        for(int i=0; i<modules.Length; i++)
        {
            var module = modules[i];
            if (module.transform.position.y > cutoffPointY)
            {
                Collider deepestModule = GetDeepestModule();
                var offset = deepestModule.bounds.min.y-module.bounds.extents.y;
                var pos = module.transform.localPosition;
                pos.y = offset - transform.position.y;
                module.transform.localPosition = pos;
            }
        }

        this.transform.position += new Vector3(0,scrollSpeed * Time.deltaTime,0);
    }

    private Collider GetDeepestModule()
    {
        float deepestPoint = 100000;
        Collider deepestCollider = null;

        for(int i=0; i<modules.Length; i++)
        {
            Collider module = modules[i];
            if (module.transform.localPosition.y < deepestPoint)
            {
                deepestPoint = module.transform.localPosition.y;
                deepestCollider = module;
            }
        }

        Debug.Log("Deepest: " + deepestCollider.name);
        return deepestCollider;
    }
}
