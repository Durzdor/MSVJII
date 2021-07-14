using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateBlades : MonoBehaviour
{
    private float rotationalSpeed;
    [SerializeField] private float rotationalSpeedDelta;
    [SerializeField] private float minRotationalSpeed;
    [SerializeField] private float maxRotationalSpeed;
    [SerializeField] private bool doesChangeSpeed;
    private bool isGoingSlow;
    private Rigidbody rb;
    [SerializeField] private float waitToDestroy;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        rotationalSpeed = maxRotationalSpeed;
        isGoingSlow = false;
    }

    private void ChangeSpeed()
    {
        if (isGoingSlow)
        {
            rotationalSpeed += rotationalSpeedDelta * Time.deltaTime;

            if (rotationalSpeed >= maxRotationalSpeed)
            {
                isGoingSlow = false;
            }
            return;
        }

        rotationalSpeed -= rotationalSpeedDelta * Time.deltaTime;

        if (rotationalSpeed <= minRotationalSpeed)
        {
            isGoingSlow = true;
        }
    }

    private void FixedUpdate()
    {
        if (doesChangeSpeed)
        {
            ChangeSpeed();
            print($"rotational speed is {rotationalSpeed}");
        }

        rb.AddTorque(transform.forward * rotationalSpeed * Time.fixedDeltaTime);
    }

    //Experimental, delete if needeed.

    /*
    private void OnJointBreak(float breakForce)
    {
        //Play destroy sound, if any.        
        StartCoroutine(DestroyWindmillBlades());
    }

    private IEnumerator DestroyWindmillBlades()
    {
        doesChangeSpeed = false;
        rotationalSpeed = 0;

        for (int i = 0; i < 10; i++)
        {
            transform.localScale *= 0.9f;
            yield return new WaitForSecondsRealtime(0.2f);
        }

        yield return new WaitForSecondsRealtime(waitToDestroy);


        Destroy(gameObject);
    }*/

}
