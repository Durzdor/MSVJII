using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateBlades : MonoBehaviour
{
    [SerializeField] private float rotationalSpeedDelta;
    public enum RotationVector
    {
        Vector3Up,
        Vector3Forward,
        Vector3Right,
    };

    [Tooltip("A que direccion apunta al principio")]
    public RotationVector desiredRotation = RotationVector.Vector3Forward;

    private void FixedUpdate()
    {
        switch (desiredRotation)
        {
            case RotationVector.Vector3Up:
                transform.Rotate(Vector3.up,rotationalSpeedDelta);
                break;
            case RotationVector.Vector3Forward:
                transform.Rotate(Vector3.forward,rotationalSpeedDelta);
                break;
            case RotationVector.Vector3Right:
                transform.Rotate(Vector3.right,rotationalSpeedDelta);
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }
    }
}
