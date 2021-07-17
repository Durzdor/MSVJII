using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Buoy : MonoBehaviour
{

    [SerializeField] private float waterDisplacement,rotationWithWater;


    [Range(0, 1)] [SerializeField] private float moveInXAxis;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        //Move up and down with waves
        float move = Mathf.Sin(Time.time);
        transform.position += move * Time.deltaTime * waterDisplacement * Vector3.up;

        //Move to sides with waves

        transform.Rotate(transform.forward * move * rotationWithWater * Time.deltaTime + transform.right * move * rotationWithWater * Time.deltaTime * moveInXAxis);
    }
}
