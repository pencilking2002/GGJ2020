using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LineDrawing : MonoBehaviour
{
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
                var worldPoint = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x,Input.mousePosition.y, 10));
                pointList.Add(worldPoint);
                pointAddedTime = Time.time;
            }
            currLine.positionCount = pointList.Count;
            currLine.SetPositions(pointList.ToArray());   
        }
        else
        {
            if (currLine != null)
            {
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
