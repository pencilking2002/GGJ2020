using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrollingManager : MonoBehaviour
{
    public GameObject[] modules;
    public float scrollSpeed = 5.0f;
    public Camera cam;


    private void Update()
    {
        var cutoffPoint = cam.ScreenToWorldPoint(new Vector3(0.5f, cam.pixelHeight, 10));
        for(int i=0; i<modules.Length; i++)
        {
            //if (modules[i].transform.)
            modules[i].transform.localPosition += new Vector3(0,scrollSpeed * Time.deltaTime,0);
        }
    }
}
