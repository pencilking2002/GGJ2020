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
    [SerializeField] private bool canDraw;
    private float pointAddedTime;
    [SerializeField] private float pointAddedInterval = 0.1f;

    private void Update()
    {
        DrawLine();
    }

    public void DrawLine()
    {
        if (canDraw)
        {
            if (Time.time > pointAddedTime + pointAddedInterval)
            {
                var worldPoint = transform.position;
                pointList.Add(worldPoint);
                pointAddedTime = Time.time;
            }

            if (pointList.Count == 0)
                return;

            currLine.positionCount = pointList.Count;
            int numPositions = pointList.Count; 
            currLine.SetPosition(numPositions-1, pointList[numPositions-1]);
            float vOffset = scrollingManager.scrollSpeed * Time.deltaTime;

            for(int x=0; x<currLine.positionCount; x++)
            {
                Vector3 linePoint = currLine.GetPosition(x);
                linePoint.y += vOffset;

                currLine.SetPosition(x, linePoint);
            } 
        }
        else
        {
            if (currLine != null)
            {
                Destroy(currLine.gameObject);
                currLine = null;
                pointList.Clear();
            }
        }
    }

    private void StartDrawing() { canDraw = true; }
    private void StopDrawing() { canDraw = false; }

    private void OnEnable()
    {
        PlayerController.OnWeldStart += StartDrawing;
        PlayerController.OnWeldStop += StopDrawing;
    }

    private void OnDisable()
    {
        PlayerController.OnWeldStart -= StartDrawing;
        PlayerController.OnWeldStop -= StopDrawing;
    }
}
