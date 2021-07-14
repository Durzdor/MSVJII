using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    private Vector3 initialDistanceToTarget;
    private Transform ballTrans;
    [SerializeField] private float cameraSpeed;

    private void Start()
    {
        ballTrans= FindObjectOfType<Ball>().transform;
        initialDistanceToTarget = transform.position - ballTrans.position;
        
    }


    private void FixedUpdate()
    {     
        Vector3 newPos = new Vector3(ballTrans.position.x, initialDistanceToTarget.y, ballTrans.position.z);
        Vector3 oldPos = ballTrans.position + initialDistanceToTarget;

        transform.position = Vector3.Lerp(oldPos, newPos, Time.deltaTime * cameraSpeed);
       
       
    }

}
