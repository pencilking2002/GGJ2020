using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private Transform leftLimit;
    [SerializeField] private Transform rightLimit;

    [SerializeField] private float playerSpeed; //How fast the player moves (not the current speed!)

    [SerializeField] private KeyCode[] moveLeft;
    [SerializeField] private KeyCode[] moveRight;

    private Vector3 startPosition;
    private Vector3 nextPosition;
    private Vector3 moveDir; //What direction the player is trying to move in

    private void Awake()
    {
        startPosition = transform.position;
    }

    private void Update()
    {
        for(int i = 0; i < moveLeft.Length; i++)
        {
            if (Input.GetKey(moveLeft[i]))
            {
                moveDir = Vector3.left;
                MovePlayer();
            }
        }

        for (int i = 0; i < moveRight.Length; i++)
        {
            if(Input.GetKey(moveRight[i]))
            {
                moveDir = Vector3.right;
                MovePlayer();
            }
        }
    }

    private void MovePlayer()
    {
        nextPosition = transform.position + (moveDir * playerSpeed * Time.deltaTime);

		if(nextPosition.x > leftLimit.position.x && nextPosition.x < rightLimit.position.x)
		{
			transform.position = nextPosition;
		}
    }

}
