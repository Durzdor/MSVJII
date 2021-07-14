using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTransitionArea : MonoBehaviour
{
    private CameraTransitionManager camTransManager;
    [SerializeField] private int cameraIndex;

    private void Start()
    {
        camTransManager = FindObjectOfType<CameraTransitionManager>();
    }



    private void OnTriggerEnter(Collider other)
    {
        camTransManager.ChangeCamera(cameraIndex);

    }
}
