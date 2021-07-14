using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTransitionManager : MonoBehaviour
{
    [SerializeField] private GameObject[] cameras;
    [SerializeField] private GameObject aerealCamera;
    private int selectedCameraIndex;
    private int lastKnownGoodPositionCamera;

    private void Start()
    {
        selectedCameraIndex = 0;   
    }

    public void ChangeCamera(int newCameraIndex)
    {


        if (newCameraIndex == selectedCameraIndex) return;

        cameras[newCameraIndex].SetActive(true);
        cameras[selectedCameraIndex].SetActive(false);
        selectedCameraIndex = newCameraIndex;
    }

    public void ChangeLastKnownGoodCamera()
    {
        lastKnownGoodPositionCamera = selectedCameraIndex;
    }

    public void ToLastKnownGoodCamera()
    {
        ChangeCamera(lastKnownGoodPositionCamera);
    }
    private void Update()
    {
        ChangeToAerealCamera();
    }
        
    private void ChangeToAerealCamera()
    {
        if (Input.GetKeyDown(KeyCode.LeftShift))
        {
            aerealCamera.SetActive(true);
        }

        if (Input.GetKeyUp(KeyCode.LeftShift))
        {
            aerealCamera.SetActive(false);
        }
    }
}
