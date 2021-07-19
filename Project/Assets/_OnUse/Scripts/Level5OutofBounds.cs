using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Level5OutofBounds : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Ball ball = other.GetComponent<Ball>();
            if (ball.Dissapearing) return;
            ball.ToKnownGoodPosition();
        }
    }
}
