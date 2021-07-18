using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StickyBall : MonoBehaviour
{
    private Ball ball;
    private Rigidbody rb;

    private void Awake()
    {
        ball = GetComponent<Ball>();
        rb = GetComponent<Rigidbody>();
    }

    private void OnCollisionEnter(Collision other)
    {
        if (other.gameObject.CompareTag("StickySurface"))
        {
            rb.Sleep();
            rb.useGravity = false;
        }
    }

    private void OnCollisionExit(Collision other)
    {
        if (other.gameObject.CompareTag("StickySurface"))
        {
            rb.useGravity = true;
        }
    }
}
