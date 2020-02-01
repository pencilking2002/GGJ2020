using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BansheeGz.BGSpline.Curve;
using BansheeGz.BGSpline.Components;

public class PlayerCurveManager : MonoBehaviour
{
    public BGCurve curve;
    public BGCcMath curveMath;

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;
        for(int sIndex=0; sIndex<curveMath.Math.SectionsCount; sIndex++)
        {
            for(int i=0; i<curveMath.Math.SectionInfos[sIndex].PointsCount; i++)
            {
                Gizmos.DrawSphere(curveMath.Math.SectionInfos[sIndex].Points[i].Position, 1);
            }
        }
    }
}
