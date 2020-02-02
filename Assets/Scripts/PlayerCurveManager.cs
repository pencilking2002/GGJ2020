using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BansheeGz.BGSpline.Curve;
using BansheeGz.BGSpline.Components;

public class PlayerCurveManager : MonoBehaviour
{
    public BGCurve curve;
    private BGCcMath curveMath;
    private List<BGCurve> curvesList = new List<BGCurve>();
    private List<BGCcMath> curveMathList = new List<BGCcMath>();
    public PlayerController player;
    public float threshold = 5.0f;
    public bool isNearCurve;

    private void Awake()
    {
        curveMath = curve.GetComponent<BGCcMath>();
        var curveArr = GameObject.FindObjectsOfType<BGCurve>();
        curvesList.AddRange(curveArr);

        foreach(var curve in curvesList)
            curveMathList.Add(curve.GetComponent<BGCcMath>());
    }

     private void OnDrawGizmos()
     {
        if (!GameManager.Instance.IsGameplayState() || !Application.isPlaying)
            return;

        if (isNearCurve)
        {
            Gizmos.color = Color.red;
            Gizmos.DrawSphere(transform.position + Vector3.up * 2, 1.0f);
        }
     }

    private void Update()
    {
        if (!GameManager.Instance.IsGameplayState())
            return;

        Vector3 closestPoint = Vector3.zero;
        for (int i=0; i<curveMathList.Count; i++)
        {
            closestPoint = curveMathList[i].Math.CalcPositionByClosestPoint(player.transform.position);
        }

        isNearCurve = (closestPoint != Vector3.zero && Vector2.Distance(closestPoint, player.transform.position) < threshold);
    }
}
