using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FishingBoat : MonoBehaviour
{
    [SerializeField] private Transform[] objectives;
    private int currentObjectiveNumber = 0;
    private Transform currentObjectiveTransform;
    [SerializeField] private float forceToUse;
    [SerializeField] private float rotationTime;
    [SerializeField] private float minDistanceToObjective;
    [SerializeField] private float waterDisplacement;
    [SerializeField] private float rotationWithWater;
    [Range(0, 1)] [SerializeField] private float moveInXAxis;
    private void Start()
    {
        currentObjectiveTransform = objectives[0];
  
    }

    private void FixedUpdate()
    {
        //XZ plane mov
        Vector3 direction = (currentObjectiveTransform.position - transform.position).normalized;

        transform.position += direction * forceToUse * Time.deltaTime;

        //Rotation

        Quaternion directionToRotate = Quaternion.LookRotation(currentObjectiveTransform.position);
        transform.rotation = Quaternion.Lerp(transform.rotation, directionToRotate, rotationTime * Time.deltaTime);

   
        if (Vector3.Distance (transform.position, currentObjectiveTransform.position) <= minDistanceToObjective)
        {
            ChangeObjective();
        }

        //Move up and down with waves
        float move = Mathf.Sin(Time.time);
        transform.position += move * Time.deltaTime * waterDisplacement * Vector3.up;

        //Move to sides with waves

        transform.Rotate(transform.forward * move * rotationWithWater * Time.deltaTime + transform.right * move * rotationWithWater * Time.deltaTime * moveInXAxis);
    }

    



    private void ChangeObjective()
    {
   
        currentObjectiveNumber++;
        if (currentObjectiveNumber > objectives.Length) currentObjectiveNumber = 0;
        currentObjectiveTransform = objectives[currentObjectiveNumber];
    }






}
