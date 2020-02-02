using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerModuleCollider : MonoBehaviour
{
    public bool isColliding;

    private void OnTriggerStay()
    {
        isColliding = true;
    }

    private void OnTriggerExit()
    {
        isColliding = false;
    }
}
