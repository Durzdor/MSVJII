using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallPositionChecker : MonoBehaviour
{
    [SerializeField] private Transform ballTransform;



    private void Update()
    {
        Shader.SetGlobalVector("BallPos", ballTransform.position);
    }







}
