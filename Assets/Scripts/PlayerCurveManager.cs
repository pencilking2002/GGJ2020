using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BansheeGz.BGSpline.Curve;
using BansheeGz.BGSpline.Components;

public class PlayerCurveManager : MonoBehaviour
{
    public BGCurve curve;
    private BGCcMath curveMath;
    private List<BGCurve> curves;

    public PlayerController player;
    public float threshold = 5.0f;
    public bool isNearCurve;

    private void Awake()
    {
        curveMath = curve.GetComponent<BGCcMath>();
        var curveArr = GameObject.FindObjectsOfType<BGCurve>();
        curves = new List<BGCurve>();
        curves.AddRange(curveArr);
    }

    // private void OnDrawGizmos()
    // {
    //     Gizmos.color = Color.yellow;
    //     Vector3 closestPoint = Vector3.zero;
    //     closestPoint = curveMath.Math.CalcPositionByClosestPoint(player.transform.position);
    //     for(int sIndex=0; sIndex<curveMath.Math.SectionsCount; sIndex++)
    //     {
    //         for(int i=0; i<curveMath.Math.SectionInfos[sIndex].PointsCount; i++)
    //         {
    //             Gizmos.DrawSphere(curveMath.Math.SectionInfos[sIndex].Points[i].Position, 0.2f);
    //         }
    //     }

    //     if (isNearCurve)
    //     {
    //         Gizmos.color = Color.red;
    //         Gizmos.DrawSphere(closestPoint, 0.25f);
    //     }
    // }

    private void Update()
    {
        Vector3 closestPoint = Vector3.zero;
        closestPoint = curveMath.Math.CalcPositionByClosestPoint(player.transform.position);
        isNearCurve = (closestPoint != Vector3.zero && Vector2.Distance(closestPoint, player.transform.position) < threshold);
    }
}
