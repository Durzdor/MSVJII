using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PneumaticValve : MonoBehaviour
{
    private Material mat;
    private int fresnelScaleID;
    private int fresnelPowerID;

    [SerializeField] private float timeToStopBlowing;
    [SerializeField] private float timeToStartBlowing;
    private float _timeToStartBlowing;
    private float _timeToStopBlowing;
    private bool isBlowing;
    [SerializeField] private float variableSpeed;

    [SerializeField] private float maxPower, minPower, maxScale, minScale;

    private AudioSource audioSrc;
    [SerializeField] private ParticleSystem particleSys;

    void Start()
    {
        
        mat = GetComponent<MeshRenderer>().material;     
        fresnelScaleID = Shader.PropertyToID("_FresnelScale");
        fresnelPowerID = Shader.PropertyToID("_FresnelPower");
        _timeToStartBlowing = timeToStartBlowing;
        _timeToStopBlowing = timeToStopBlowing;

        audioSrc = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
        //While blowing

        if (isBlowing)
        {
            _timeToStopBlowing -= Time.deltaTime;

            mat.SetFloat(fresnelScaleID, Mathf.Lerp(mat.GetFloat(fresnelScaleID), maxScale, Time.deltaTime * variableSpeed));
            mat.SetFloat(fresnelPowerID, Mathf.Lerp(mat.GetFloat(fresnelPowerID), minPower, Time.deltaTime * variableSpeed));            

            if (_timeToStopBlowing <= 0)
            {
                _timeToStopBlowing = timeToStopBlowing;
                audioSrc.Play();
                particleSys.Play();
                isBlowing = false;
            }
            return;
        }


        //Until it starts to blow
        _timeToStartBlowing -= Time.deltaTime;

        mat.SetFloat(fresnelScaleID, Mathf.Lerp(mat.GetFloat(fresnelScaleID), minScale, Time.deltaTime * variableSpeed));
        mat.SetFloat(fresnelPowerID, Mathf.Lerp(mat.GetFloat(fresnelPowerID), maxPower, Time.deltaTime * variableSpeed));

        if (_timeToStartBlowing <= 0)
        {
            _timeToStartBlowing = timeToStartBlowing;
            isBlowing = true;
        }
    }

  
}
