using System.Collections.Generic;
using UnityEngine;
using BansheeGz.BGSpline.Curve;
using BansheeGz.BGSpline.Components;

public class PlayerCurveManager : MonoBehaviour
{
    public BGCurve curve;
    private BGCcMath curveMath;
    private List<BGCurve> curvesList = new List<BGCurve>();
    public List<BGCcMath> curveMathList = new List<BGCcMath>();
    public BGCcMath closestMathCurve;
    public float threshold = 5.0f;
    public bool isNearCurve;
    private Vector3 closestPoint;
    
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
        if (!Application.isPlaying)
            return;

        if (!GameManager.Instance.IsGameplayState())
            return;

        if (isNearCurve)
        {
            Gizmos.color = Color.red;
            Gizmos.DrawSphere(transform.position + Vector3.up * 2, 1.0f);
        }

        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(closestPoint, 1.0f);

     }

    private void Update()
    {
        if (!GameManager.Instance.IsGameplayState())
            return;

        closestPoint = GetClosestPoint();

        isNearCurve = Vector2.Distance(closestPoint, transform.position) < threshold;
//        Debug.Log(Vector2.Distance(closestPoint, transform.position));
    }

    private Vector3 GetClosestPoint()
    {
        Vector3 closestPoint = default;
        
        for (int i=0; i<curveMathList.Count; i++)
        {   
            Vector3 point = curveMathList[i].Math.CalcPositionByClosestPoint(transform.position);
            float currPointDistance = Vector2.Distance(point, transform.position);
            float currClosestPointDistance = Vector2.Distance(closestPoint, transform.position); 

            if (closestPoint == default || currPointDistance < currClosestPointDistance)
            {
                closestPoint = point;
                closestMathCurve = curveMathList[i];
            }
        }
        return closestPoint;
    }

    // private BGCcMath GetClosestCurveMath()
    // {
    //     BGCcMath curveMath;
    //     for (int i=0; i<curveMathList.Count; i++)
    //     {

    //     }
    // }
}
