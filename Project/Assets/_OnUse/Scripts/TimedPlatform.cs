using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimedPlatform : MonoBehaviour
{
    [SerializeField] private float delayToStart = 0;
    [SerializeField] private float timeToDisappear = 0;
    [SerializeField] private float timeWithoutCollider = 0;
    private float timeToFirstChange;
    private float maxTimeToFirst;
    private float maxTimeToDisappear;
    private float maxTimeWithoutCollider;
    private MeshRenderer meshRenderer;
    [SerializeField] private Material firstChangeMat;
    [SerializeField] private Material disappearChangeMat;
    private Material defaultMat;
    private bool isFirstChangeDone;
    private BoxCollider boxCollider;
    private Rigidbody rb;

    private void Awake()
    {
        meshRenderer = GetComponent<MeshRenderer>();
        boxCollider = GetComponent<BoxCollider>();
        rb = GetComponent<Rigidbody>();
        defaultMat = meshRenderer.material;
        maxTimeToDisappear = timeToDisappear;
        timeToFirstChange = maxTimeToDisappear / 2;
        maxTimeToFirst = timeToFirstChange;
        maxTimeWithoutCollider = timeWithoutCollider;
    }

    private void Update()
    {
        if (delayToStart > 0)
        {
            delayToStart -= Time.deltaTime;
            return;
        }
        timeToFirstChange -= Time.deltaTime;
        timeToDisappear -= Time.deltaTime;
        if (timeToFirstChange <= 0)
        {
            if (!isFirstChangeDone)
            {
                meshRenderer.material = firstChangeMat;
                isFirstChangeDone = true;
            }
        }

        if (timeToDisappear <= 0)
        {
            meshRenderer.material = disappearChangeMat;
            //boxCollider.enabled = false;
            rb.detectCollisions = false;
            timeWithoutCollider -= Time.deltaTime;
            if (timeWithoutCollider <= 0)
            {
                rb.detectCollisions = true;
                //boxCollider.enabled = true;
                meshRenderer.material = defaultMat;
                isFirstChangeDone = false;
                timeToFirstChange = maxTimeToFirst;
                timeToDisappear = maxTimeToDisappear;
                timeWithoutCollider = maxTimeWithoutCollider;
            }
        }
    }
}
