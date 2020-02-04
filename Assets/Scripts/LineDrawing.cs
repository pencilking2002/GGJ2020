using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LineDrawing : MonoBehaviour
{
    public ScrollingManager scrollingManager;
    public LineRenderer lrPrefab;
    private LineRenderer _currLine;
    public LineRenderer currLine
    {
        get 
        { 
            if (_currLine == null)
            {
                _currLine = Instantiate(lrPrefab).GetComponent<LineRenderer>();
                _currLine.transform.position = Vector3.zero;
            }

            return _currLine; 
        }

        set {}
    }
    public List<Vector3> pointList;
    [SerializeField] private float pointAddedInterval = 0.1f;
    [SerializeField] private float maxTrailLength = 4.0f;         // How long is the feedback welding trail
    [SerializeField] private float currTrailLength = 0.0f;
    [SerializeField] private float trailLerpSpeed = 5.0f;
    private float pointAddedTime;

    private void Update()
    {
        DrawLine();
    }

    public void DrawLine()
    {
     
        if (!GameManager.Instance.IsGameplayState())
            return;

        var mathCurve = GameManager.Instance.player.curveManager.closestMathCurve.Math;
        var closestLineRenderer = GameManager.Instance.player.curveManager.closestLineRenderer;

        if (GameManager.Instance.player.isWeldingOnCurve)
        {
            pointList.Clear();
            currLine.positionCount = 0;
            // currLine.positionCount = 1;
            // currLine.SetPosition(0, transform.position);

            currTrailLength = Mathf.Lerp(currTrailLength, maxTrailLength, trailLerpSpeed * Time.deltaTime);
            
            // for(int sIndex=0; sIndex<mathCurve.SectionsCount; sIndex++)
            // {
            //     var section = mathCurve.SectionInfos[sIndex];
            //     for(int pIndex=0; pIndex < section.PointsCount; pIndex++)
            //     {
            //         if (section.points[pIndex].Position.y > transform.position.y && 
            //             section.points[pIndex].Position.y < transform.position.y + currTrailLength)
            //         {
            //             var linePoint = section.points[pIndex].Position;
            //             linePoint.z -= 0.1f;
            //             pointList.Add(linePoint);
            //             currLine.positionCount = pointList.Count;
            //             currLine.SetPosition(pointList.Count-1, linePoint);
            //         }
            //     }
            // }

            // currLine.positionCount = pointList.Count;
            // currLine.SetPositions(pointList.ToArray());
            for (int i=0; i<closestLineRenderer.positionCount; i++)
            {
                Vector3 linePoint = closestLineRenderer.GetPosition(i);

                if (linePoint.y > transform.position.y && linePoint.y < transform.position.y + currTrailLength)
                {
                    //var linePoint = section.points[pIndex].Position;
                    linePoint.z -= 0.1f;
                    pointList.Add(linePoint);
                    currLine.positionCount = pointList.Count;
                    currLine.SetPosition(pointList.Count-1, linePoint);
                }
            }
        }
        else
        {
            currTrailLength = Mathf.Lerp(currTrailLength, 0.0f, trailLerpSpeed * Time.deltaTime);
            //if (currLine != null)
            //{
                //Destroy(currLine.gameObject);
                currLine.positionCount = 0;
                //currLine = null;
                //pointList.Clear();
            //}
        }
        
    }

    private void OnEnable()
    {
       
    }

    private void OnDisable()
    {
    
    }

    // private void OnDrawGizmos()
    // {
    //      if (!Application.isPlaying)
    //         return;

    //     if (!GameManager.Instance.IsGameplayState())
    //         return;

    //     var mathCurve = GameManager.Instance.player.curveManager.closestMathCurve.Math;
    //     if (GameManager.Instance.player.isWeldingOnCurve)
    //     {
            
    //         Gizmos.color = Color.white;
    //         currTrailLength = Mathf.Lerp(currTrailLength, maxTrailLength, trailLerpSpeed * Time.deltaTime);

    //         for(int sIndex=0; sIndex<mathCurve.SectionsCount; sIndex++)
    //         {
    //             var section = mathCurve.SectionInfos[sIndex];
    //             for(int pIndex=0; pIndex < section.PointsCount; pIndex++)
    //             {
    //                 if (section.points[pIndex].Position.y > transform.position.y && 
    //                     section.points[pIndex].Position.y < transform.position.y + currTrailLength)
    //                 {
    //                     Gizmos.DrawSphere(section.points[pIndex].Position, 1.0f);
    //                 }
    //             }
    //         }
    //     }
    //     else
    //     {
    //         currTrailLength = Mathf.Lerp(currTrailLength, 0.0f, trailLerpSpeed * Time.deltaTime);
    //     }
    // }
}
